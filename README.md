# spatialfinal2021
Spatial Epidemiology final project, Fall 2021

# Next Steps 

- Create a Table 1 (all cities combined and per city and by HOLC category) - Susan
- Create redlining maps - Jasmine 
- Creating combined dataset with redlining and NATA data - Leah 

# Outcome information 

Outcomes of interest (by source group, census tract):
- 2014 NATA national reproductive HI
- 2014 NATA national developmental HI

Hazard quotient: The ratio of the exposure to the substance at the level at which no adverse effects are expected.  <=1 indicates noncancer effect not likely to occur 

Hazard index: The sum of the hazard quotients for toxics that affect the same target organ/target system.  An HI <=1 indicates noncancer effect not likely to occur 

# Exposure information 

Exposure (Aggregated to census tract):
- Redlining 

# Confounders 

We have not identified confounders as redlining is so far in the past, any covariates would be mediators.  We are interested in the total effect and therefore will not be considering these variables. 

# Data editing 

EJScreen data: 
- For ease of importing to GitHub, we limited the data to only areas within GA before loading the dataset to the project 

# Dataset information 

HOLC_full: Census tract + HOLC data, all Georgia census tracts
HOLC_full_georgia: Census tract + HOLC data, all Georgia census tracts, only GA census tracts with HOLC data
HOLC_full_atlanta: Census tract + HOLC data, only census tracts in Atlanta with HOLC data
HOLC_full_augusta: Census tract + HOLC data, only census tracts in Augusta with HOLC data
HOLC_full_columbus: Census tract + HOLC data, only census tracts in Columbus with HOLC data
HOLC_full_macon: Census tract + HOLC data, only census tracts in Macon with HOLC data
HOLC_full_savannah: Census tract + HOLC data, only census tracts in Savannah with HOLC data

Data convention HOLC_map_cityname will be used to create datasets with extra census tracts for mapping purposes. Need to still figure out how we want to present those maps.
