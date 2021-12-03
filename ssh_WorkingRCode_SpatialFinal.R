#### Set-up ####

# Packages 

library(tmap)
library(tidyverse)
library(dplyr)
library(sp)
library(readxl)
library(rgdal)
library(readr)
library(ggplot2)

# Data files

## outcome data
ej_ga <- read_csv("Data/ej_ga.csv", 
                  col_types = cols(...1 = col_skip())) %>% 
  select('ID', 'DSLPM', 'CANCER', 'RESP')

## exposure geometry data 
HOLC_map <- readOGR(dsn=path.expand("Data/HRS2010-Shapefiles/HRS2010"),
                    layer="HRS2010")
## exposure attribute data
HOLC_score <- read_excel("Data/Historic Redlining Score 2010.xlsx")

## Importing Georgia Census Tract Geographic Boundary file
## updated 2020 data
 
ga_tracts_10 <- readOGR(dsn=path.expand("Data/tl_2020_13_all"),layer="tl_2020_13_tract10")

#### Data editing ####

# Cleaning HOLC score data
HOLC_score2 <- HOLC_score %>% 
  filter(substr(GEOID10,1,2) == "13") # restricting to only GA

# cleaning EJScreen data 

ej_ga2 <- ej_ga %>% 
  mutate(GEOID10 = substr(ej_ga$ID, 1, 11)) %>% 
  select(-'ID')

ej_ga2 <- ej_ga2[!duplicated(ej_ga2$GEOID10),]

ej_ga2 <- sp::merge(ga_tracts_10, ej_ga2, 
                    by = 'GEOID10', 
                    all.y = T,
                    duplicateGeoms = T,
                    na.strings = 'Missing')

full_data <- sp::merge(ej_ga2, HOLC_score2, 
                       by = 'GEOID10', 
                       all.y = T,
                       duplicateGeoms = T,
                       na.strings = 'Missing')

summary(full_data)

writeOGR(obj=full_data, dsn="Data/tempdir", layer="full_data", driver="ESRI Shapefile")

#### final working data ####

full_data <- readOGR(dsn=path.expand("Data/tempdir"),layer="full_data") # all census tracts

full_data_georgia <- readOGR(dsn=path.expand("Data/tempdir"),layer="full_data_georgia") # only have census tracts with HOLC data
full_data_atlanta <- readOGR(dsn=path.expand("Data/tempdir"),layer="full_data_atlanta") # only have census tracts with HOLC data
full_data_augusta <- readOGR(dsn=path.expand("Data/tempdir"),layer="full_data_augusta") # only have census tracts with HOLC data
full_data_macon <- readOGR(dsn=path.expand("Data/tempdir"),layer="full_data_macon") # only have census tracts with HOLC data
full_data_savannah <- readOGR(dsn=path.expand("Data/tempdir"),layer="full_data_savannah") # only have census tracts with HOLC data
full_data_columbus <- readOGR(dsn=path.expand("Data/tempdir"),layer="full_data_columbus") # only have census tracts with HOLC data

#### 15 panel map - local quantiles ####

# Diesel PM

dpm_atl <- tm_shape(full_data_atlanta) +
  tm_fill('DSLPM',
          style = 'quantile',
          palette = 'BuPu',
          title = 'Diesel PM') +
  tm_borders() +
  tm_layout(main.title = 'Diesel PM: \nAtlanta',
            main.title.size = 0.9,
            legend.outside = T,
            legend.outside.size = .5,
            frame = F)

dpm_atl


dpm_aug <- tm_shape(full_data_augusta) +
  tm_fill('DSLPM',
          style = 'quantile',
          palette = 'BuPu',
          title = 'Diesel PM') +
  tm_borders() +
  tm_layout(#main.title = 'Diesel PM: \nAugusta',
            #main.title.size = 0.9,
            legend.outside = T,
            legend.outside.size = .5,
            frame = F)

dpm_aug

dpm_mac <- tm_shape(full_data_macon) +
  tm_fill('DSLPM',
          style = 'quantile',
          palette = 'BuPu',
          title = 'Diesel PM') +
  tm_borders() +
  tm_layout(#main.title = 'Diesel PM: \nMacon',
            #main.title.size = 0.9,
            legend.outside = T,
            legend.outside.size = .5,
            frame = F)

dpm_mac

dpm_sav <- tm_shape(full_data_savannah) +
  tm_fill('DSLPM',
          style = 'quantile',
          palette = 'BuPu',
          title = 'Diesel PM') +
  tm_borders() +
  tm_layout(#main.title = 'Diesel PM: \nSavannah',
            #main.title.size = 0.9,
            legend.outside = T,
            legend.outside.size = .5,
            frame = F)

dpm_sav

dpm_col <- tm_shape(full_data_columbus) +
  tm_fill('DSLPM',
          style = 'quantile',
          palette = 'BuPu',
          title = 'Diesel PM') +
  tm_borders() +
  tm_layout(#main.title = 'Diesel PM: \nColumbus',
            #main.title.size = 0.9,
            legend.outside = T,
            legend.outside.size = .5,
            frame = F)

dpm_col

# RESP

res_atl <- tm_shape(full_data_atlanta) +
  tm_fill('RESP',
          style = 'quantile',
          palette = 'RdPu',
          title = 'Repiratory Hazard') +
  tm_borders() +
  tm_layout(#main.title = 'Respiratory Hazard: \nAtlanta',
           # main.title.size = 0.9,
            legend.outside = T,
            legend.outside.size = .5,
            frame = F)

res_atl

res_aug <- tm_shape(full_data_augusta) +
  tm_fill('RESP',
          style = 'quantile',
          palette = 'RdPu',
          title = 'Repiratory Hazard') +
  tm_borders() +
  tm_layout(#main.title = 'Respiratory Hazard: \nAugusta',
            #main.title.size = 0.9,
            legend.outside = T,
            legend.outside.size = .5,
            frame = F)

res_aug

res_mac <- tm_shape(full_data_macon) +
  tm_fill('RESP',
          style = 'quantile',
          palette = 'RdPu',
          title = 'Repiratory Hazard') +
  tm_borders() +
  tm_layout(#main.title = 'Respiratory Hazard: \nMacon',
            #main.title.size = 0.9,
            legend.outside = T,
            legend.outside.size = .5,
            frame = F)

res_mac

res_sav <- tm_shape(full_data_savannah) +
  tm_fill('RESP',
          style = 'quantile',
          palette = 'RdPu',
          title = 'Repiratory Hazard') +
  tm_borders() +
  tm_layout(#main.title = 'Respiratory Hazard: \nSavannah',
            #main.title.size = 0.9,
            legend.outside = T,
            legend.outside.size = .5,
            frame = F)

res_sav

res_col <- tm_shape(full_data_columbus) +
  tm_fill('RESP',
          style = 'quantile',
          palette = 'RdPu',
          title = 'Repiratory Hazard') +
  tm_borders() +
  tm_layout(#main.title = 'Respiratory Hazard: \nColumbus',
            #main.title.size = 0.9,
            legend.outside = T,
            legend.outside.size = .5,
            frame = F)
res_col

# Cancer

can_atl <- tm_shape(full_data_atlanta) +
  tm_fill('CANCER',
          style = 'quantile',
          palette = 'PuBu',
          title = 'Cancer Risk') +
  tm_borders() +
  tm_layout(#main.title = 'Cancer Hazard: \nAtlanta',
           # main.title.size = 0.9,
            legend.outside = T,
            legend.outside.size = .5,
            frame = F)

can_atl

can_aug <- tm_shape(full_data_augusta) +
  tm_fill('CANCER',
          style = 'quantile',
          palette = 'PuBu',
          title = 'Cancer Risk') +
  tm_borders() +
  tm_layout(#main.title = 'Cancer Hazard: \nAugusta',
            #main.title.size = 0.9,
            legend.outside = T,
            legend.outside.size = .5,
            frame = F)

can_aug

can_mac <- tm_shape(full_data_macon) +
  tm_fill('CANCER',
          style = 'quantile',
          palette = 'PuBu',
          title = 'Cancer Risk') +
  tm_borders() +
  tm_layout(#main.title = 'Cancer Hazard: \nMacon',
            #main.title.size = 0.9,
            legend.outside = T,
            legend.outside.size = .5,
            frame = F)

can_mac

can_sav <- tm_shape(full_data_savannah) +
  tm_fill('CANCER',
          style = 'quantile',
          palette = 'PuBu',
          title = 'Cancer Risk') +
  tm_borders() +
  tm_layout(#main.title = 'Cancer Hazard: \nSavannah',
           # main.title.size = 0.9,
            legend.outside = T,
            legend.outside.size = .5,
            frame = F)

can_sav

can_col <- tm_shape(full_data_columbus) +
  tm_fill('CANCER',
          style = 'quantile',
          palette = 'PuBu',
          title = 'Cancer Risk') +
  tm_borders() +
  tm_layout(#main.title = 'Cancer Hazard: \nColumbus',
            #main.title.size = 0.9,
            legend.outside = T,
            legend.outside.size = .5,
            frame = F)
can_col

tmap_arrange(dpm_atl, dpm_aug, dpm_sav, dpm_mac, dpm_col,
             res_atl, res_aug, res_sav, res_mac, res_col,
             can_atl, can_aug, can_sav, can_mac, can_col,
             nrow = 3,
             ncol = 5)




#### 15 panel map - full data quantiles ####

# Diesel PM

# Finding universal quantile 
quantile(full_data_georgia$DSLPM, na.rm = T)

dpm_atl <- tm_shape(full_data_atlanta) +
  tm_fill('DSLPM',
          style = 'fixed',
          breaks = c(0.3808355, 0.5959913, 0.7397038, 0.9065605, 1.4902905),
          palette = 'BuPu') +
  tm_borders() +
  tm_layout(main.title = 'Diesel PM: \nAtlanta',
            main.title.size = 0.9,
            legend.show = F)

dpm_aug <- tm_shape(full_data_augusta) +
  tm_fill('DSLPM',
          style = 'fixed',
          breaks = c(0.3808355, 0.5959913, 0.7397038, 0.9065605, 1.4902905),
          palette = 'BuPu') +
  tm_borders() +
  tm_layout(main.title = 'Diesel PM: \nAugusta',
            main.title.size = 0.9,
            legend.show = F)

dpm_mac <- tm_shape(full_data_macon) +
  tm_fill('DSLPM',
          style = 'fixed',
          breaks = c(0.3808355, 0.5959913, 0.7397038, 0.9065605, 1.4902905),
          palette = 'BuPu') +
  tm_borders() +
  tm_layout(main.title = 'Diesel PM: \nMacon',
            main.title.size = 0.9,
            legend.show = F)

dpm_sav <- tm_shape(full_data_savannah) +
  tm_fill('DSLPM',
          style = 'fixed',
          breaks = c(0.3808355, 0.5959913, 0.7397038, 0.9065605, 1.4902905),
          palette = 'BuPu') +
  tm_borders() +
  tm_layout(main.title = 'Diesel PM: \nSavannah',
            main.title.size = 0.9,
            legend.show = F)

dpm_col <- tm_shape(full_data_columbus) +
  tm_fill('DSLPM',
          style = 'fixed',
          breaks = c(0.3808355, 0.5959913, 0.7397038, 0.9065605, 1.4902905),
          palette = 'BuPu',
          title = 'Diesel PM') +
  tm_borders() +
  tm_layout(main.title = 'Diesel PM: \nColumbus',
            main.title.size = 0.9,
            legend.outside = T,
            legend.outside.size = 0.5)

# RESP

# Finding universal quantile 
quantile(full_data_georgia$RESP, na.rm = T)

res_atl <- tm_shape(full_data_atlanta) +
  tm_fill('RESP',
          style = 'fixed',
          breaks = c(0.4995681, 0.6531644, 0.6916693, 0.7364947, 0.8608944),
          palette = 'RdPu') +
  tm_borders() +
  tm_layout(main.title = 'Respiratory Hazard: \nAtlanta',
            main.title.size = 0.9,
            legend.show = F)

res_aug <- tm_shape(full_data_augusta) +
  tm_fill('RESP',
          style = 'fixed',
          breaks = c(0.4995681, 0.6531644, 0.6916693, 0.7364947, 0.8608944),
          palette = 'RdPu') +
  tm_borders() +
  tm_layout(main.title = 'Respiratory Hazard: \nAugusta',
            main.title.size = 0.9,
            legend.show = F)

res_mac <- tm_shape(full_data_macon) +
  tm_fill('RESP',
          style = 'fixed',
          breaks = c(0.4995681, 0.6531644, 0.6916693, 0.7364947, 0.8608944),
          palette = 'RdPu') +
  tm_borders() +
  tm_layout(main.title = 'Respiratory Hazard: \nMacon',
            main.title.size = 0.9,
            legend.show = F)

res_sav <- tm_shape(full_data_savannah) +
  tm_fill('RESP',
          style = 'fixed',
          breaks = c(0.4995681, 0.6531644, 0.6916693, 0.7364947, 0.8608944),
          palette = 'RdPu') +
  tm_borders() +
  tm_layout(main.title = 'Respiratory Hazard: \nSavannah',
            main.title.size = 0.9,
            legend.show = F)

res_col <- tm_shape(full_data_columbus) +
  tm_fill('RESP',
          style = 'fixed',
          breaks = c(0.4995681, 0.6531644, 0.6916693, 0.7364947, 0.8608944),
          palette = 'RdPu',
          title = 'Repiratory Hazard') +
  tm_borders() +
  tm_layout(main.title = 'Respiratory Hazard: \nColumbus',
            main.title.size = 0.9,
            legend.outside = T,
            legend.outside.size = 0.5)

# Cancer

# Finding universal quantile 
quantile(full_data_georgia$CANCER, na.rm = T)

can_atl <- tm_shape(full_data_atlanta) +
  tm_fill('CANCER',
          style = 'fixed',
          breaks = c(34.64623, 46.95583, 52.63795, 55.89212, 69.16529),
          palette = 'PuBu') +
  tm_borders() +
  tm_layout(main.title = 'Cancer Hazard: \nAtlanta',
            main.title.size = 0.9,
            legend.show = F)

can_aug <- tm_shape(full_data_augusta) +
  tm_fill('CANCER',
          style = 'fixed',
          breaks = c(34.64623, 46.95583, 52.63795, 55.89212, 69.16529),
          palette = 'PuBu') +
  tm_borders() +
  tm_layout(main.title = 'Cancer Hazard: \nAugusta',
            main.title.size = 0.9,
            legend.show = F)

can_mac <- tm_shape(full_data_macon) +
  tm_fill('CANCER',
          style = 'fixed',
          breaks = c(34.64623, 46.95583, 52.63795, 55.89212, 69.16529),
          palette = 'PuBu') +
  tm_borders() +
  tm_layout(main.title = 'Cancer Hazard: \nMacon',
            main.title.size = 0.9,
            legend.show = F)

can_sav <- tm_shape(full_data_savannah) +
  tm_fill('CANCER',
          style = 'fixed',
          breaks = c(34.64623, 46.95583, 52.63795, 55.89212, 69.16529),
          palette = 'PuBu') +
  tm_borders() +
  tm_layout(main.title = 'Cancer Hazard: \nSavannah',
            main.title.size = 0.9,
            legend.show = F)

can_col <- tm_shape(full_data_columbus) +
  tm_fill('CANCER',
          style = 'fixed',
          breaks = c(34.64623, 46.95583, 52.63795, 55.89212, 69.16529),
          palette = 'PuBu',
          title = 'Cancer Hazard') +
  tm_borders() +
  tm_layout(main.title = 'Cancer Hazard: \nColumbus',
            main.title.size = 0.9,
            legend.outside = T,
            legend.outside.size = 0.5)

tmap_arrange(dpm_atl, dpm_aug, dpm_sav, dpm_mac, dpm_col,
             res_atl, res_aug, res_sav, res_mac, res_col,
             can_atl, can_aug, can_sav, can_mac, can_col,
             nrow = 3,
             ncol = 5)

#### density plot graph ####

hist <- as.data.frame(full_data_georgia) %>% 
  select(c(CBSA, CANCER, DSLPM, RESP)) 

hist$cities <- factor(hist$CBSA,
                      levels = c(12060, 42340, 17980, 31420, 12260), 
                      labels = c('Atlanta', 'Savannah', 'Columbus', 'Macon', 'Augusta'))
  

dslpm <- ggplot(hist, aes(x = DSLPM, fill = cities)) +
  geom_density(alpha = 0.4) +
  ggtitle('NATA Diesel PM Density per City in Georgia') +
  xlab('Diesel PM') +
  ylab('Density') +
  labs(fill = 'HOLC Regions') +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        axis.line = element_line(colour = "black")) 

cancer <- ggplot(hist, aes(x = CANCER, fill = cities)) +
  geom_density(alpha = 0.4) +
  ggtitle('Cancer Risk per City in Georgia') +
  xlab('Cancer Risk') +
  ylab('Density') +
  labs(fill = 'HOLC Regions') +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        axis.line = element_line(colour = "black")) 

resp <- ggplot(hist, aes(x = RESP, fill = cities)) +
  geom_density(alpha = 0.4) +
  ggtitle('Respiratory Hazard per City in Georgia') +
  xlab('Respiratory Hazard') +
  ylab('Density') +
  labs(fill = 'HOLC Regions') +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        axis.line = element_line(colour = "black")) 
  

resp
cancer
dslpm


#### Example Code ####

# Density plots 

# Basic density
p <- ggplot(df, aes(x=weight)) + 
  geom_density()
p
# Add mean line
p+ geom_vline(aes(xintercept=mean(weight)),
              color="blue", linetype="dashed", size=1)

# Reading and writing a .shp file 
x <- readOGR(dsn=path.expand("Data/tempdir"),layer="HOLC_full")
writeOGR(obj=full_data, dsn="Data/tempdir", layer="full_data", driver="ESRI Shapefile")

# finding nas 
apply(is.na(ej_ga2), 2, sum)
