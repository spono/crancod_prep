#### set variables ####

# path to the CRANCOD data files
wdir = file.path("C:","Users","","")

# set files' name (without extension)
fname = "test"

#++++++++++++++++++++++++++++++++++++++++ LIBRARIES +++++++++++++++++++++++++++++++++++++++++++++++#

require("NISTunits")
require("ggplot2")
require("XLConnect")# NB. install Java according to the R architecture you're using! (32 or 64 bit)

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#

if(!(dir.exists(file.path(wdir,"input","plot_imgs"))))
{
  dir.create(file.path(wdir,"comma_dec"), showWarnings=TRUE, recursive=TRUE)
}


setwd(wdir)

fileList = list.files(wdir, pattern="\\.out$")


for (i in 1:length(fileList))
{
  setwd(wdir)
  tbl = read.table(fileList[i], sep="\t", dec=".", fill=TRUE)
  sheetName = substr(fileList[i], 1, nchar(fileList[i])-nchar("_org.out"))
  for (j in 1:ncol(tbl))
  {
    tbl[,j] = gsub(".", ",", tbl[,j], fixed = TRUE)
  }
  setwd(file.path(wdir,"comma_dec"))
  write.table(tbl, paste0(sheetName,".txt"), sep="\t", row.names = FALSE, col.names = FALSE, quote=FALSE)
}
setwd(wdir)


#### output in Excel format (doesn't work perfectly...) ####

# wb <- loadWorkbook(paste0(fname, "_output.xlsx"), create = TRUE)
# 
# for (i in 1:length(fileList))
# {
#   tbl = read.table(fileList[i], sep="\t", dec=".", fill=TRUE)
#   sheetName = substr(fileList[i], nchar(fname)+2, nchar(fileList[i])-nchar("_org.out"))
#   createSheet(wb, name = sheetName)
#   for (j in 1:ncol(tbl))
#   {
#     tbl[,j] = gsub(".", ",", tbl[,j], fixed = TRUE)
#   }
#   setwd(file.path(wdir,"comma_dec"))
#   writeWorksheet(wb, tbl, sheet = sheetName, header=FALSE)
# }
# saveWorkbook(wb)
