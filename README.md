# reproduce_test 
Testing reproducibility of a ranger function on Mac.

## Detailed explanation of scripts 
The following items are attached:
* rf_prepare.R, which is a data preparation file that just has the be sourced in the model_one.R script
* model_one.R, is the script where the ranger function is set to be run with the seed
* check.Rproj, is the project I ran the scripts on my personal device
* housing.csv, the dataset 


## Packages that are needed
*tidyverse
*dplyr
*reshape2
*ranger
*dplyr
*ggplot2

##These were my results
*OOB prediction error : 4806113672
*R squared (OOB) : 0.6444524
