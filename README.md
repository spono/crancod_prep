# CRANCOD - DATA PREPARATION
Scripts for data preparation to comply with the [CRANCOD software](http://www.pommerening.org/wiki/index.php?title=CRANCOD_-_A_Program_for_the_Analysis_and_Reconstruction_of_Spatial_Forest_Structure).




INSTRUCTIONS
----------------

**DATA PREPARATION**

The 'CRANCOD_data_file.xlsx' file is meant to be a single file with all the necessary data for the creation of properly
 formatted input files for CRANCOD.
1. Fill the form in the worksheet 'cfg' with the necessary information. The folder path MUST include the name of the input files
 without the extension; the proper extension will be added to each output of the 'CRANCOD_data_preparation' R script.
2. Copy the data to the 'dat' worksheet, leaving the 'Ydim'
3. Fill in with the geometry data the 'geo' worksheet, leaving the 'Ydim' empty in case of circular plots
4. Do not change the 'species' file

**WARNING!** The 'dat' and 'geo' worksheets do have the column names to help the data entry: they'll removed automatically from
 the R script, in order to comply with the rules of CRANCOD.


**DATA POST-PROCESSING**
The 'CRANCOD_post-processing'script is meant to automatically change 'periods' into 'commas' and then produce easily readable
 files (.csv or .xlsx).
