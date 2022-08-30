# DEFINE GLOBAL PARAMETERS ####################################################

## .Renviron Setup ############################################################
# the following line creates a .Renviron file  
usethis::edit_r_environ('project')
# include the following in the .Renviron file then save and close
#DATA_PATH = "~/OneDrive - University of Kansas/PROJECT/DATA"

## Load DATA_PATH #############################################################
# this uses the path from the .Renviron file
data_path <- Sys.getenv('DATA_PATH')

# Example Parameters
# beg_year and end_year to define the sample period
beg_year <- 2000
# the assignment arrow is an R grammar style, but equal signs work too
end_year = 2021