#### Workflow ####
# Keep all packages and data at the top 
# Work on R code only in your section.  
# If you are trying to help troubleshoot, copy/paste to your section 
# Move finalized code to the RMarkdown

#### Set Up ####

# Packages 

library(sf)
library(tmap)
library(tidyverse)
library(dplyr)
library(raster)
library(rgdal)
library(readxl)

# Data

## outcome data
EJscreen <- read.csv("Data/ej_ga.csv")

## exposure geometry data 
HOLC_map <- readOGR(dsn=path.expand("Data/HRS2020-Shapefiles/HRS2020"),
                    layer="HRS2020")
## exposure attribute data
HOLC_score <- read_excel("Data/Historic Redlining Score 2020.xlsx")


#### Jasmine ####



#### Leah ####


#### Susan ####