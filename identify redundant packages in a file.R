# FILE DESCRIPTION ############################################################
# For a description of the purpose of this file, read the discussion at
# https://towardsdatascience.com/r-you-sure-youre-using-this-package-8ce265a990b0)

# CHECKS FOR THE NCMISC PACKAGE, AND INSTALLS IT IF NEEDED ####################
if (!require("NCmisc")) install.packages("NCmisc")

# LOAD LIBRARIES ##############################################################
library(NCmisc)

# RUN list.functions.in.file ##################################################
p <- NCmisc::list.functions.in.file("~/GitHub/stem-gcm/code/prepare the data for DEFAULT coding.R")
summary(p)