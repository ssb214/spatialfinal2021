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

### Creating subset dataset and redlining maps

## Import main dataset
full_data <- readOGR(dsn=path.expand("tempdir"),layer="full_data") # all census tracts

# Projecting data to Albers Equal Area
full_data <- st_transform(full_data, 5070) # project data to Albers Equal Area

## Import the exposure attribute data
HOLC_score <- read_excel("Historic Redlining Score 2010.xlsx")

HOLC_score2 <- HOLC_score %>% 
  filter(substr(GEOID10,1,2) == "13") # restricting to only GA

MyPalette <- c("#A8FF33", "#81F0FF", "#FAFF93", "#FF9693")
MyLabels <- c("Low (Q1)", "Medium (Q2)", "High (Q3)", "Very High (Q4)")

# All GA
ga_ids <- HOLC_score2$GEOID10
full_data_georgia <- subset(full_data, GEOID10 %in% ga_ids)
summary(full_data_georgia)
writeOGR(obj=full_data_georgia, dsn="tempdir", layer="full_data_georgia", driver="ESRI Shapefile")

# Atlanta only
atlanta <- HOLC_score2 %>% 
  filter(CBSA=="12060")
atlanta_ids <- atlanta$GEOID10
full_data_atlanta <- subset(full_data, GEOID10 %in% atlanta_ids)
summary(full_data_atlanta)
writeOGR(obj=full_data_atlanta, dsn="tempdir", layer="full_data_atlanta", driver="ESRI Shapefile")

a <- tm_shape(full_data_atlanta) + 
  tm_fill('HRS10',
          n = 4,
          style = 'quantile',
          palette = MyPalette, 
          labels = MyLabels, 
          title = "Historic Redlining Score") +
  tm_borders() +
  tm_layout(legend.position = c('RIGHT', 'BOTTOM'), legend.title.size = 1, legend.text.size = 0.8,
            main.title = "Atlanta", main.title.size = 1) 

a

# Augusta only
augusta <- HOLC_score2 %>% 
  filter(CBSA=="12260")
augusta_ids <- augusta$GEOID10
full_data_augusta<- subset(full_data, GEOID10 %in% augusta_ids)
summary(full_data_augusta)
writeOGR(obj=full_data_augusta, dsn="tempdir", layer="full_data_augusta", driver="ESRI Shapefile")

b <- tm_shape(full_data_augusta) + 
  tm_fill('HRS10',
          n = 4,
          style = 'quantile',
          palette = MyPalette, 
          labels = MyLabels, 
          title = "Historic Redlining Score") +
  tm_borders() +
  tm_layout(legend.position = c('LEFT', 'BOTTOM'), legend.title.size = 1, legend.text.size = 0.8,
            main.title = "Augusta", main.title.size = 1) 

b  

# Columbus only
columbus <- HOLC_score2 %>% 
  filter(CBSA=="17980")
columbus_ids <- columbus$GEOID10
full_data_columbus <- subset(full_data, GEOID10 %in% columbus_ids)
summary(full_data_columbus)
writeOGR(obj=full_data_columbus, dsn="tempdir", layer="full_data_columbus", driver="ESRI Shapefile")

c <- tm_shape(full_data_columbus) + 
  tm_fill('HRS10',
          n = 4,
          style = 'quantile',
          palette = MyPalette, 
          labels = MyLabels, 
          title = "Historic Redlining Score") +
  tm_borders() +
  tm_layout(legend.position = c('LEFT', 'BOTTOM'), legend.title.size = 0.8, legend.text.size = 0.8,
            main.title = "Columbus", main.title.size = 1) 

c  

# Macon only
macon <- HOLC_score2 %>% 
  filter(CBSA=="31420")
macon_ids <- macon$GEOID10
full_data_macon <- subset(full_data, GEOID10 %in% macon_ids)
summary(full_data_macon)
writeOGR(obj=full_data_macon, dsn="tempdir", layer="full_data_macon", driver="ESRI Shapefile")


d <- tm_shape(full_data_macon) + 
  tm_fill('HRS10',
          n = 4,
          style = 'quantile',
          palette = MyPalette, 
          labels = MyLabels, 
          title = "Historic Redlining Score") +
  tm_borders() +
  tm_layout(legend.position = c('LEFT', 'BOTTOM'), legend.title.size = 1, legend.text.size = 0.8,
            main.title = "Macon", main.title.size = 1) 

d

# Savannah only
savannah <- HOLC_score2 %>% 
  filter(CBSA=="42340")
savannah_ids <- savannah$GEOID10
full_data_savannah <- subset(full_data, GEOID10 %in% savannah_ids)
summary(full_data_savannah)
writeOGR(obj=full_data_savannah, dsn="tempdir", layer="full_data_savannah", driver="ESRI Shapefile")


e <- tm_shape(full_data_savannah) + 
  tm_fill('HRS10',
          n = 4,
          style = 'quantile',
          palette = MyPalette, 
          labels = MyLabels, 
          title = "Historic Redlining Score") +
  tm_borders() +
  tm_layout(legend.position = c('LEFT', 'BOTTOM'), legend.title.size = 1, legend.text.size = 0.8,
            main.title = "Savannah", main.title.size = 1) 


e


tmap_arrange(a, b, c, d, e)


























### ARCHIVED CODE - broken right now because of 2010 census data

### Creating the datasets for redlining descriptive maps
  
### 1 Loading the data
  
## Importing the exposure geometry data 
HOLC_map <- readOGR(dsn=path.expand("HRS2010-Shapefiles/HRS2010"),layer="HRS2010")

HOLC_map_ga <- HOLC_map %>% 
  filter(substr(GEOID10,1,2) == "13")

HOLC_map_ga <- HOLC_map[HOLC_map$METRO_NAME==c("Savannah, GA","Atlanta-Sandy Springs-Roswell")]
   
## Importing the exposure attribute data
HOLC_score <- read_excel("Historic Redlining Score 2010.xlsx")

## Importing Georgia Census Tract Geographic Boundary file
# updated 2020 data
ga_tracts_20 <- readOGR(dsn=path.expand("tl_2020_13_all"),layer="tl_2020_13_tract20")
# Trying our 2010 data
ga_tracts_10 <- readOGR(dsn=path.expand("tl_2020_13_all"),layer="tl_2020_13_tract10")

### 2 Cleaning and creating datasets for analysis

## Cleaning HOLC score data
HOLC_score2 <- HOLC_score %>% 
  filter(substr(GEOID10,1,2) == "13") # restricting to only GA


## Merging attribute dataset with geography dataset

# with 2010 census - need to go with this one 1969-2621=175, so no tracts were excluded
HOLC_full <- sp::merge(ga_tracts_10, HOLC_map, by = "GEOID10", all.y=F, duplicateGeoms = TRUE, na.strings = 'Missing') 
summary(HOLC_full)

tm_shape(HOLC_full) + 
  tm_fill('HRS2020',
          n = 4,
          style = 'quantile',
          palette = MyPalette, 
          labels = MyLabels, 
          title = "Historic Redlining Score by Quartile") +
  tm_borders()

## Modeling datasets - i.e., only tracts with HOLC data

# All GA
ga_ids <- HOLC_score2$GEOID20
HOLC_full_georgia <- subset(HOLC_full, GEOID20 %in% ga_ids)
plot(HOLC_full_georgia)

tm_shape(HOLC_full_georgia) + 
  tm_fill('HRS20',
          n = 4,
          style = 'quantile',
          palette = MyPalette, 
          labels = MyLabels, 
          title = "Historic Redlining Score by Quartile") +
  tm_borders()

# Atlanta only
atlanta <- HOLC_score2 %>% 
  filter(CBSA=="12060")
atlanta_ids <- atlanta$GEOID20
HOLC_full_atlanta <- subset(HOLC_full, GEOID20 %in% atlanta_ids)
plot(HOLC_full_atlanta)

a <- tm_shape(HOLC_map_atlanta) + 
  tm_fill('HRS20',
          n = 4,
          style = 'quantile',
          palette = MyPalette, 
          labels = MyLabels, 
          title = "Historic Redlining Score by Quartile") +
  tm_borders()

# Augusta only
augusta <- HOLC_score2 %>% 
  filter(CBSA=="12260")
augusta_ids <- augusta$GEOID20
HOLC_full_augusta <- subset(HOLC_full, GEOID20 %in% augusta_ids)
plot(HOLC_full_augusta)

b <- tm_shape(HOLC_full_augusta) + 
  tm_fill('HRS20',
          n = 4,
          style = 'quantile',
          palette = MyPalette, 
          labels = MyLabels, 
          title = "Historic Redlining Score by Quartile") +
  tm_borders()

# Columbus only
columbus <- HOLC_score2 %>% 
  filter(CBSA=="17980")
columbus_ids <- columbus$GEOID20
HOLC_full_columbus <- subset(HOLC_full, GEOID20 %in% columbus_ids)
plot(HOLC_full_columbus)

c <- tm_shape(HOLC_full_columbus) + 
  tm_fill('HRS20',
          n = 4,
          style = 'quantile',
          palette = MyPalette, 
          labels = MyLabels, 
          title = "Historic Redlining Score by Quartile") +
  tm_borders()

# Macon only
macon <- HOLC_score2 %>% 
  filter(CBSA=="31420")
macon_ids <- macon$GEOID20
HOLC_full_macon <- subset(HOLC_full, GEOID20 %in% macon_ids)
plot(HOLC_full_macon)

d <- tm_shape(HOLC_full_macon) + 
  tm_fill('HRS20',
          n = 4,
          style = 'quantile',
          palette = MyPalette, 
          labels = MyLabels, 
          title = "Historic Redlining Score by Quartile") +
  tm_borders()

# Savannah only
savannah <- HOLC_score2 %>% 
  filter(CBSA=="42340")
savannah_ids <- savannah$GEOID20
HOLC_full_savannah <- subset(HOLC_full, GEOID20 %in% savannah_ids)
plot(HOLC_full_savannah)

e <- tm_shape(HOLC_full_savannah) + 
  tm_fill('HRS20',
          n = 4,
          style = 'quantile',
          palette = MyPalette, 
          labels = MyLabels, 
          title = "Historic Redlining Score by Quartile") +
  tm_borders()


tmap_arrange(a, b, c, d, e)






## Exporting datasets


dir.create("tempdir")

writeOGR(obj=HOLC_full, dsn="tempdir", layer="HOLC_full", driver="ESRI Shapefile")
writeOGR(obj=HOLC_full_atlanta, dsn="tempdir", layer="HOLC_full_atlanta", driver="ESRI Shapefile")
writeOGR(obj=HOLC_full_augusta, dsn="tempdir", layer="HOLC_full_augusta", driver="ESRI Shapefile")
writeOGR(obj=HOLC_full_macon, dsn="tempdir", layer="HOLC_full_macon", driver="ESRI Shapefile")
writeOGR(obj=HOLC_full_savannah, dsn="tempdir", layer="HOLC_full_savannah", driver="ESRI Shapefile")
writeOGR(obj=HOLC_full_columbus, dsn="tempdir", layer="HOLC_full_columbus", driver="ESRI Shapefile")


## Subsetting full_data
full_data <- readOGR(dsn=path.expand("tempdir"),layer="full_data")
summary(full_data)

# All GA

ga_ids <- HOLC_score2$GEOID10
full_data_georgia <- subset(full_data, GEOID20 %in% ga_ids)
summary(full_data_georgia)
writeOGR(obj=full_data_georgia, dsn="tempdir", layer="full_data_georgia", driver="ESRI Shapefile")


# Atlanta only
atlanta <- HOLC_score2 %>% 
  filter(CBSA=="12060")
atlanta_ids <- atlanta$GEOID20
full_data_atlanta <- subset(full_data, GEOID20 %in% atlanta_ids)
summary(full_data_atlanta)
writeOGR(obj=full_data_atlanta, dsn="tempdir", layer="full_data_atlanta", driver="ESRI Shapefile")

# Augusta only
augusta <- HOLC_score2 %>% 
  filter(CBSA=="12260")
augusta_ids <- augusta$GEOID20
full_data_augusta<- subset(full_data, GEOID20 %in% augusta_ids)
summary(full_data_augusta)
writeOGR(obj=full_data_augusta, dsn="tempdir", layer="full_data_augusta", driver="ESRI Shapefile")

# Columbus only
columbus <- HOLC_score2 %>% 
  filter(CBSA=="17980")
columbus_ids <- columbus$GEOID20
full_data_columbus <- subset(full_data, GEOID20 %in% columbus_ids)
summary(full_data_columbus)
writeOGR(obj=full_data_columbus, dsn="tempdir", layer="full_data_columbus", driver="ESRI Shapefile")

# Macon only
macon <- HOLC_score2 %>% 
  filter(CBSA=="31420")
macons_ids <- macon$GEOID20
full_data_macon <- subset(full_data, GEOID20 %in% macon_ids)
summary(full_data_macon)
writeOGR(obj=full_data_macon, dsn="tempdir", layer="full_data_macon", driver="ESRI Shapefile")


# Savannah only
savannah <- HOLC_score2 %>% 
  filter(CBSA=="42340")
savannah_ids <- savannah$GEOID20
full_data_savannah <- subset(full_data, GEOID20 %in% savannah_ids)
summary(full_data_savannah)
writeOGR(obj=full_data_savannah, dsn="tempdir", layer="full_data_savannah", driver="ESRI Shapefile")









### Code drafts

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





# trying a subset for mapping
HOLC_full_savannah <- HOLC_full[HOLC_full$COUNTYFP20 == "051",]

HOLC_full_savannah_2 <- HOLC_full[HOLC_full$CBSA == "42340", ]

MyPalette <- c("#A8FF33", "#81F0FF", "#FAFF93", "#FF9693")
MyLabels <- c("Low (Q1)", "Medium (Q2)", "High (Q3)", "Very High (Q4)")

tm_shape(HOLC_full_savannah) + 
  tm_fill('HRS20',
          n = 4,
          style = 'quantile',
          palette = MyPalette, 
          labels = MyLabels, 
          title = "Historic Redlining Score by Quartile") +
  tm_borders()


tm_shape(HOLC_full) + 
  tm_fill('HRS20',
          n = 4,
          style = 'quantile',
          palette = MyPalette, 
          labels = MyLabels, 
          title = "Historic Redlining Score by Quartile") +
  tm_borders() 


  tm_shape(ga_roads_20) + 
  tm_lines(lwd = 2, col = 'red') 

# notes: need to figure out how many "background" census tracts we want in each map - in savannah map, I just included the whole county
# need to figure out if we want to add more detail to the map


# how to import datasets
  full_data <- readOGR(dsn=path.expand("tempdir"),layer="full_data") # all census tracts
  full_data_georgia <- readOGR(dsn=path.expand("tempdir"),layer="full_data_georgia") # only has census tracts with HOLC data
  full_data_atlanta <- readOGR(dsn=path.expand("tempdir"),layer="full_data_atlanta") # only has census tracts with HOLC data
  full_data_augusta <- readOGR(dsn=path.expand("tempdir"),layer="full_data_augusta") # only has census tracts with HOLC data
  full_data_macon <- readOGR(dsn=path.expand("tempdir"),layer="full_data_macon") # only has census tracts with HOLC data
  full_data_savannah <- readOGR(dsn=path.expand("tempdir"),layer="full_data_savannah") # only has census tracts with HOLC data
  full_data_columbus <- readOGR(dsn=path.expand("tempdir"),layer="full_data_columbus") # only has census tracts with HOLC data
  
  
  

  
  
  

