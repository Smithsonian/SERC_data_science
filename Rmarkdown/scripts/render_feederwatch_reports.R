## This is a program script that runs an annual report for feederwatch

library(tidyverse)
library(gganimate)
library(gifski)
library(readxl)
library(DT)
library(leaflet)
library(plotly)

# Read in data
data_raw <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2023/2023-01-10/PFW_2021_public.csv')
# site_data <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2023/2023-01-10/PFW_count_site_data_public_2021.csv')

species_ref <- readxl::read_xlsx("Rmarkdown/data/FeederWatch_Data_Dictionary.xlsx", sheet = "Species Codes", skip = 1)
names(species_ref) <- tolower(names(species_ref)) # adjust to make this 

## Clean the data

# prepare dataset for analysis
data_clean <- data_raw %>% 
  left_join(species_ref %>% select(species_code, sci_name, primary_com_name, category)) %>% 
  separate(subnational1_code, into = c("country", "state"), sep = "-") %>% 
  mutate(date = as.Date(paste(Year, Month, Day, sep = "-"))) %>% 
  filter(valid == 1, country == "US", category == "species")
# only keep valid observations from the US id to the species level

data_clean %>% group_by(state) %>% summarise(n = sum(how_many)) %>% arrange(desc(n))

## Generate Reports 
selected_states <- c("NY") #  "FL", "TX", "CA", "OH"

lapply(selected_states, function(state.i) {
  rmarkdown::render("Rmarkdown/scripts/feederwatch_template.Rmd",
                    params = list(state = state.i),
                    output_file = paste0("Feederwatch_", state.i, ".html"), 
                    output_dir = "Rmarkdown/reports")
})
