#  ***************************************************************************
#   CRANCOD_post-processing.R
#  ---------------------
#   Date                 : January 2019
#   Copyright            : (C) 2019 by Niccolò Marchi
#   Email                : niccolo.marchi@phd.unipd.it
#  ---------------------
#   
#  This script converts the decimal format (from period to comma) through all 
#  the outputs after running CRANCOD.
#  ***************************************************************************

#### set variables ####

# path to the CRANCOD data files
wdir = file.path("C:","Users","","")

# set files' name (without extension)
fname = "test"

#++++++++++++++++++++++++++++++++++++++++ LIBRARIES +++++++++++++++++++++++++++++++++++++++++++++++#

require("NISTunits")
require("ggplot2")
#require("XLConnect")# NB. install Java according to the R architecture you're using! (32 or 64 bit)

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#

if(!(dir.exists(file.path(wdir,"input","plot_imgs"))))
{
  dir.create(file.path(wdir,"comma_dec"), showWarnings=TRUE, recursive=TRUE)
}


setwd(wdir)

fileList = list.files(wdir, pattern="\\.out$")


out.list = list()

for (i in 1:length(fileList))
{
  setwd(wdir)
  tbl = read.table(fileList[i], sep="\t", dec=".", fill=TRUE)
  sheetName = substr(fileList[i], 1, nchar(fileList[i])-nchar("_org.out"))
  for (j in 1:ncol(tbl))
  {
    tbl[,j] = gsub(".", ",", tbl[,j], fixed = TRUE)
  }
  #setwd(file.path(wdir,"comma_dec"))
  #write.table(tbl, paste0(sheetName,".txt"), sep="\t", row.names = FALSE, col.names = FALSE, quote=FALSE)
  out.list[[sheetName]] = fdata
}
#setwd(wdir)

writexl::write_xlsx(out.list, path=file.path(out.folder, paste0('summary_stats_comma_dec.xlsx')) )

