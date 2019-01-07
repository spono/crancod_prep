#  ***************************************************************************
#   CRANCOD_data_preparation.R
#  ---------------------
#   Date                 : January 2019
#   Copyright            : (C) 2019 by Niccolò Marchi
#   Email                : niccolo.marchi@phd.unipd.it
#  ---------------------
#   
#  This script creates the four files necessary for a corret run of CRANCOD.
#  Make sure to fill the excel file as required
#  ***************************************************************************


#### set variables ####

# path to the CRANCOD data files
wdir = file.path("C:","Users","","")

# name of the CRANCOD data file (with extension)
data.file = "CRANCOD_data_file.xlsx"

# set files' name (without extension)
fname = "test"




#++++++++++++++++++++++++++++++++++++++++ LIBRARIES +++++++++++++++++++++++++++++++++++++++++++++++#

require("NISTunits")
require("ggplot2")
require("XLConnect")# NB. install Java according to the R architecture you're using! (32 or 64 bit)

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#

setwd(wdir)


# Load in the Workbook
wb <- loadWorkbook(data.file)


# create directory for images
if(!(dir.exists(file.path(wdir,"input","plot_imgs"))))
{
  dir.create(file.path(wdir,"input","plot_imgs"), showWarnings=TRUE, recursive=TRUE)
}

setwd(file.path(wdir,"input"))


#### configuration file ####

# Load in Worksheet
cfg <- readWorksheet(wb, sheet="cfg", header=FALSE)

# export
file.create(paste0(fname,".cfg"))

cat(paste0(cfg[1,1],"\n", cfg[2,1],"\n",
           file.path(wdir,"input",fname), "\n", # add path and file name
           cfg[4,1],"\n", cfg[5,1],"\n", cfg[6,1],"\n", cfg[7,1],
           "\n", cfg[8,1],"\n", cfg[9,1],"\n", cfg[10,1],"\n", cfg[11,1],"\n", cfg[12,1],"\n", cfg[13,1],"\n", cfg[14,1],
           "\n", cfg[15,1],"\t", cfg[15,2],"\t", cfg[15,3],"\t", cfg[15,4],"\n", cfg[16,1],"\n", cfg[17,1],
           "\t", cfg[17,2],"\n", cfg[18,1],"\n", cfg[19,1],"\t", cfg[19,2],"\n", cfg[20,1],"\n", cfg[21,1],
           "\t", cfg[21,2],"\n", cfg[22,1],"\n", cfg[23,1],"\t", cfg[23,2],"\n", cfg[24,1],
           "\n", cfg[25,1],"\n", cfg[26,1],"\n", cfg[27,1],"\t", cfg[27,2],"\t", cfg[27,3],"\n", cfg[28,1],
           "\n", cfg[29,1],"\n", cfg[30,1],"\n", cfg[31,1],"\t", cfg[31,2],"\t", cfg[31,3],"\t", cfg[31,4],
           "\n", cfg[32,1],"\n", cfg[33,1],"\n", cfg[34,1],"\n", cfg[35,1],"\n", cfg[36,1],"\n", cfg[37,1],
           "\n", cfg[38,1],"\n", cfg[39,1],"\n", cfg[40,1],"\n", cfg[41,1],"\t", cfg[41,2]),
    file=paste0(fname,".cfg"))


#### data file ####

# Load in Worksheet
dat <- readWorksheet(wb, sheet="dat")

# set decimal positions as mandatory
dat$az_Xcoord = format(round(dat$az_Xcoord, 3), nsmall = 3)
dat$az_Xcoord = gsub(" ", "", dat$az_Xcoord, fixed = TRUE) # removes whitespaces from data

dat$dist_Ycoord = format(round(dat$dist_Ycoord, 3), nsmall = 3)
dat$dist_Ycoord = gsub(" ", "", dat$dist_Ycoord, fixed = TRUE)

dat$DBH = format(round(dat$DBH, 1), nsmall = 1)
dat$DBH = gsub(" ", "", dat$DBH, fixed = TRUE)

dat$tree_H = format(round(dat$tree_H, 1), nsmall = 1)
dat$tree_H = gsub(" ", "", dat$tree_H, fixed = TRUE)


# export
write.table(dat, paste0(fname,".dat"), sep="\t", row.names = FALSE, col.names = FALSE,
            dec = ".", quote=FALSE)



#### geometry file ####

# Load in Worksheet
geo <- readWorksheet(wb, sheet="geo")

# drop the third column if dealing with circular plots
if (cfg[7,1] == 1){geo = geo[,c(1,2,4,5)]}

# set decimal positions as mandatory
geo$rad_Xdim = format(round(geo$rad_Xdim, 1), nsmall = 1)
geo$rad_Xdim = gsub(" ", "", geo$rad_Xdim, fixed = TRUE)

if (cfg[7,1] == 0){geo$Ydim = format(round(geo$Ydim, 1), nsmall = 1)
geo$Ydim = gsub(" ", "", geo$Ydim, fixed = TRUE)}

geo$Xcoord = format(round(geo$Xcoord, 3), nsmall = 3)
geo$Xcoord = gsub(" ", "", geo$Xcoord, fixed = TRUE)

geo$Ycoord = format(round(geo$Ycoord, 3), nsmall = 3)
geo$Ycoord = gsub(" ", "", geo$Ycoord, fixed = TRUE)

# export
write.table(geo, paste0(fname,".geo"), sep="\t", row.names = FALSE, col.names = FALSE,
            dec = ".", quote=FALSE)


#### species file ####

# Load in Worksheet
species <- readWorksheet(wb, sheet="species", header=FALSE)
# export
write.table(species, paste0(fname,".species"), sep="\t", row.names = FALSE, col.names = FALSE,
            dec = ".", quote=FALSE)

species = subset(species, select=c(species,latin_name))


#### export tree spatial distribution ####

setwd(file.path(wdir,"input","plot_imgs"))

dat = read.table(file.path(wdir,"input",paste0(fname,".dat")), sep="\t", dec=".", fill=TRUE)
colnames(dat) = c("plot_num","tree_num","species","az_Xcoord","dist_Ycoord","DBH","tree_H")

dat = merge(dat, species, by="species")

for (i in unique(dat$plot_num))
{
  ss = subset(dat, plot_num == i)
  
  if (cfg[7,1] == 1){ss$X = sin(NISTdegTOradian(ss$az_Xcoord))* ss$dist_Ycoord
  ss$Y = cos(NISTdegTOradian(ss$az_Xcoord))* ss$dist_Ycoord} else {ss$X = ss$az_Xcoord
  ss$Y = ss$dist_Ycoord}
  
  alim = as.numeric(unique(geo$rad_Xdim))
  
  ggplot(ss, aes(x=X, y=Y, size=DBH)) +
    #scale_shape_discrete(solid=FALSE) + # make simbols hollow
    geom_point(aes(shape=common_name,colour=common_name)) + # for a constant size, add here 'size=5' and remove above
    coord_fixed(ratio = 1)+
    #coord_cartesian(xlim = c(-alim, alim),
    #                ylim = c(-alim, alim)) + # sets a fixed value range among the plots equal to the maximum radius
    ggtitle(paste("Plot n.",i))+
    labs(x="", y="")+
    theme_bw()+
    guides(size=FALSE)+ # remove the legend related to 'size'
    theme(plot.title = element_text(hjust = 0.5),
          legend.title = element_blank(),
          legend.position = "bottom")+
    coord_fixed(ratio=1/1)
  
  ggsave(paste0("plot_",i,".png"), height = 5, width = 7)
}
rm(ss)

setwd(wdir) # this allows to unlock the folder



