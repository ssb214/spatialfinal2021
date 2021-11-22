# spatialfinal2021
Spatial Epidemiology final project, Fall 2021

# Outcome information 

Outcomes of interest (by census tract):

- National Scale Air Toxics Assessment Air Toxics Cancer Risk (CANCER)
- National Scale Air Toxics Assessment Respiratory Hazard Index (RESP)
- National Scale Air Toxics Assessment Diesel PM (DPM) (DSLPM)

Hazard quotient: The ratio of the exposure to the substance at the level at which no adverse effects are expected.  <=1 indicates noncancer effect not likely to occur 

Hazard index: The sum of the hazard quotients for toxics that affect the same target organ/target system.  An HI <=1 indicates noncancer effect not likely to occur 

Cancer risk: the probability of contracting cancer over a lifetime, assuming continuous exposure (assumed in NATA to be 70 years) 

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

# Analysis Plan

- Treating each metropolitan area as a spatial island 
- We will calculate the Global Moran's I for each area to see if a spatial or aspatial model would be appropriate
- If Global Moran's I is insignificant we will move forward with an aspatial model
- If Global Moran's I is significant and a spatial model is appropriate, we will conduct Spatial Durbin Model 
