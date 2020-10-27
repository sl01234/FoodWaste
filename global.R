library(leaflet)
library(shiny)
library(tidyverse)
library(ggmap)
library(rgdal)
library(sp)
library(plotly)
library(htmltools)
register_google(key = 'AIzaSyASeP2PsgtXuG2e1CM58o2RyIERFnRXtCg')

# Read in files
shpfile <- readOGR(dsn=getwd(), layer="TM_WORLD_BORDERS_SIMPL-0.3")
shpfile@data$ID <- 1:nrow(shpfile@data)
View(shpfile@data)
wideAgg_allYears <- read.csv("~/Desktop/NYCDSA/SHINY_PROJECT/Foodwaste/wideAgg_allYears.csv")
wideAgg_allYears <- wideAgg_allYears[!is.na(wideAgg_allYears$grpRegion),]

iso3_2014 <- read.csv("~/Desktop/NYCDSA/SHINY_PROJECT/FoodWaste/iso3_2014.csv", stringsAsFactors=FALSE)

# Read in barplot2 files
gathered_percentage_cereals <- read.csv("~/Desktop/NYCDSA/SHINY_PROJECT/FoodWaste/gathered_percentage_cereals.csv", stringsAsFactors=FALSE)
gathered_percentage_dairyandeggs <- read.csv("~/Desktop/NYCDSA/SHINY_PROJECT/FoodWaste/gathered_percentage_dairyandeggs.csv", stringsAsFactors=FALSE)
gathered_percentage_fishandseafood <- read.csv("~/Desktop/NYCDSA/SHINY_PROJECT/FoodWaste/gathered_percentage_fishandseafood.csv", stringsAsFactors=FALSE)
gathered_percentage_fruitsandvegetables <- read.csv("~/Desktop/NYCDSA/SHINY_PROJECT/FoodWaste/gathered_percentage_fruitsandvegetables.csv", stringsAsFactors=FALSE)
gathered_percentage_meat <- read.csv("~/Desktop/NYCDSA/SHINY_PROJECT/FoodWaste/gathered_percentage_meat.csv", stringsAsFactors=FALSE)
gathered_percentage_oilseedsandpulses <- read.csv("~/Desktop/NYCDSA/SHINY_PROJECT/FoodWaste/gathered_percentage_oilseedsandpulses.csv", stringsAsFactors=FALSE)
gathered_percentage_rootsandtubers <- read.csv("~/Desktop/NYCDSA/SHINY_PROJECT/FoodWaste/gathered_percentage_rootsandtubers.csv", stringsAsFactors=FALSE)
gathered_percentage_stage_allFoodGroups <- read.csv("~/Desktop/NYCDSA/SHINY_PROJECT/FoodWaste/gathered_percentage_stage_allFoodGroups.csv", stringsAsFactors=FALSE)
View(gathered_percentage_stage_allFoodGroups)

# Collapsed one observation per country so no duplicate layer info for leaflet labels
agg_foodgroup_2014_pivot <- read.csv("~/Desktop/NYCDSA/SHINY_PROJECT/FoodWaste/agg_foodgroup_2014_pivot.csv", stringsAsFactors=FALSE)
agg_foodgroup_2015_pivot <- read.csv("~/Desktop/NYCDSA/SHINY_PROJECT/FoodWaste/agg_foodgroup_2015_pivot.csv", stringsAsFactors=FALSE)
agg_foodgroup_2016_pivot <- read.csv("~/Desktop/NYCDSA/SHINY_PROJECT/FoodWaste/agg_foodgroup_2016_pivot.csv", stringsAsFactors=FALSE)
agg_foodgroup_2017_pivot <- read.csv("~/Desktop/NYCDSA/SHINY_PROJECT/FoodWaste/agg_foodgroup_2017_pivot.csv", stringsAsFactors=FALSE)

# Add 'Year' column before merge into one file
agg_foodgroup_2014_pivot['Year'] <- '2014'
agg_foodgroup_2015_pivot['Year'] <- '2015'
agg_foodgroup_2016_pivot['Year'] <- '2016'
agg_foodgroup_2017_pivot['Year'] <- '2017'

# Merge collapsed files into one 2014-2017
agg_foodgroups_allYears <- bind_rows(agg_foodgroup_2014_pivot, agg_foodgroup_2015_pivot, agg_foodgroup_2016_pivot, agg_foodgroup_2017_pivot)

# Leaflet map base
merged_2014_shpfile <- merge(x = shpfile,   # find iso3_2014. Already write.csv
                             y = iso3_2014,
                             by.x = "ISO3",
                             by.y = "CODE",
                             duplicateGeoms = TRUE)

# Leaflet 2014, will merge into years 2014-2017
merged_2014_shpfile2 <- merge(x = shpfile,   
                              y = agg_foodgroup_2014_pivot,
                              by.x = "ISO3",
                              by.y = "X.1")

View(shpfile@data)
# Leaflet 2015, will merge into years 2014-2017
merged_2015_shpfile2 <- merge(x = shpfile,   
                              y = agg_foodgroup_2015_pivot,
                              by.x = "ISO3",
                              by.y = "X.1")

# Leaflet 2016, will merge into years 2014-2017
merged_2016_shpfile2 <- merge(x = shpfile,   # find iso3_2014. Already write.csv
                              y = agg_foodgroup_2016_pivot,
                              by.x = "ISO3",
                              by.y = "X.1")

merged_2017_shpfile2 <- merge(x = shpfile,   # find iso3_2014. Already write.csv
                              y = agg_foodgroup_2017_pivot,
                              by.x = "ISO3",
                              by.y = "X.1")
# Merged leaflet shpfile 2014-2017
merged_agg_allYears_shpfile2 <- raster::bind(merged_2014_shpfile2, merged_2015_shpfile2, merged_2016_shpfile2, merged_2017_shpfile2)
View(merged_agg_allYears_shpfile2@data)
