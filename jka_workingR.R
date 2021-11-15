# Jasmine's working file


pacman::p_load(tidyverse, # General data wrangling
               raster,
               rgdal,
               sp,
               readxl,
               sf, # manage spatial data using simple features
               tmap,
               tidycensus
               ) # mapping of sf or sp data




EJscreen <- read.csv("Data/ej_ga.csv")


  library(tidycensus)
  library(tidyverse)
  library(viridis)
  census_api_key("584ad55d1dfd1ad1025ac5de1005b5640ba7b973")
  vars10 <- c("P005003", "P005004", "P005006", "P004003")

  
  ga_tract <- get_decennial(geography = "tract", variables = vars10, year = 2010,
                      summary_var = "P001001", state = "GA", geometry = TRUE) %>%
    mutate(pct = 100 * (value / summary_value))
  
  ga_block <- get_decennial(geography = "block", variables = vars10, year = 2010,
                      summary_var = "P001001", state = "GA", geometry = TRUE) %>%
    mutate(pct = 100 * (value / summary_value))
  


