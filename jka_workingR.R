# EPI 563
# Spatial Final Project
# Jasmine's working file

### Packages

pacman::p_load(tidyverse,    # general data wrangling
               tidycensus,   # importing Census attribute data into R
               sf,           # Spatial data classes
               tmap,         # Mapping/cartography
               tigris,       # importing Census geography into R
               dplyr,        # general data manipulation
               SpatialEpi,   # spatial analysis package with Empirical Bayes
               spdep,        # spatial analysis package for defining neighbors
               GWmodel,
               kableExtra,   # extra table making
               DCluster,     # package with functions for spatial cluster analysis
               raster,
               rgdal,
               sp,
               readxl, 
               viridis)               

### Figuring out how to combine GA geography data with EJ screen data

EJscreen <- read.csv("Data/ej_ga.csv")

census_api_key("584ad55d1dfd1ad1025ac5de1005b5640ba7b973")
vars10 <- c("P005003", "P005004", "P005006", "P004003")
  
il <- get_decennial(geography = "county", variables = vars10, year = 2010,
                      summary_var = "P001001", state = "IL", geometry = TRUE) %>%
    mutate(pct = 100 * (value / summary_value))
  
ga_tract <- get_decennial(geography = "tract", variables = vars10, year = 2010,
                      summary_var = "P001001", state = "GA", geometry = TRUE) %>%
    mutate(pct = 100 * (value / summary_value))
  
ga_block <- get_decennial(geography = "block", variables = vars10, year = 2010,
                      summary_var = "P001001", state = "GA", geometry = TRUE) %>%
    mutate(pct = 100 * (value / summary_value))
  






### Creating the redlining descriptive maps
  
### 1 Loading the data
  
# Importing the exposure geometry data 
HOLC_map <- readOGR(dsn=path.expand("HRS2020-Shapefiles/HRS2020"),layer="HRS2020")
   
# Importing the exposure attribute data
HOLC_score <- read_excel("Historic Redlining Score 2020.xlsx")

# Importing Georgia Census Tract Geographic Boundary file
# updated 2020 data
ga_tracts_20 <- readOGR(dsn=path.expand("tl_2020_13_all"),layer="tl_2020_13_tract20")


### 2 Cleaning and creating datasets for analysis

# Cleaning HOLC score data
HOLC_score2 <- HOLC_score %>% 
  filter(substr(GEOID20,1,2) == "13") # restricting to only GA

# Cleaning HOLC map data

# All GA
ga_ids <- HOLC_score2$GEOID20
HOLC_map_ga <- subset(HOLC_map, GEOID20 %in% ga_ids) # restricting to only GA

# Atlanta only
atlanta <- HOLC_score2 %>% 
  filter(CBSA=="12060")
atlanta_ids <- atlanta$GEOID20
HOLC_map_atlanta <- subset(HOLC_map, GEOID20 %in% atlanta_ids)
plot(HOLC_map_atlanta)

# Augusta only
augusta <- HOLC_score2 %>% 
  filter(CBSA=="12260")
augusta_ids <- augusta$GEOID20
HOLC_map_augusta <- subset(HOLC_map, GEOID20 %in% augusta_ids)
plot(HOLC_map_augusta)

# Columbus only
columbus <- HOLC_score2 %>% 
  filter(CBSA=="17980")
columbus_ids <- columbus$GEOID20
HOLC_map_columbus <- subset(HOLC_map, GEOID20 %in% columbus_ids)
plot(HOLC_map_columbus)

# Macon only
macon <- HOLC_score2 %>% 
  filter(CBSA=="31420")
macon_ids <- macon$GEOID20
HOLC_map_macon <- subset(HOLC_map, GEOID20 %in% macon_ids)
plot(HOLC_map_macon)

# Savannah only
savannah <- HOLC_score2 %>% 
  filter(CBSA=="42340")
savannah_ids <- savannah$GEOID20
HOLC_map_savannah <- subset(HOLC_map, GEOID20 %in% savannah_ids)
plot(HOLC_map_savannah)


# Merging attribute dataset with geography dataset

# with 2020 census - need to go with this one 2796-2621=175, so no tracts were excluded
HOLC_full <- sp::merge(ga_tracts_20, HOLC_score2, by = "GEOID20", all.y=T, duplicateGeoms = TRUE, na.strings = 'Missing') 
summary(HOLC_full)




# trying a subset
HOLC_full_savannah <- HOLC_full[HOLC_full$COUNTYFP20 == "051",]


tm_shape(HOLC_full_savannah) + 
  tm_fill('HRS20',
          n = 4,
          style = 'quantile',
          palette = 'BuPu') +
  tm_borders()

# notes: need to figure out how many "background" census tracts we want in each map - in savannah map, I just included the whole county
# need to figure out if we want to add more detail to the map


