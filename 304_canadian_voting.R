install.packages("janitor")
install.packages("tidyverses")
library(janitor)
library(tidyverse)
set.seed(1)
simulated_data <-
  tibble(
    "Division" = 1:338,
    "Party" = sample(
      x = c("Liberal", "Conservative", "Bloc Québécois", "New Democratic”", "Green"),
      size = 338,
      replace = TRUE
    )
  )

simulated_data

library(readr)
raw_elections_data <-
  read_csv(
      "/Users/frankstrove/Downloads/table_tableau11.csv",
    show_col_types = FALSE,
    skip = 1
  )

write_csv(
  x = raw_elections_data,
  file = "canadian_voting.csv"
)

head(raw_elections_data)
tail(raw_elections_data)

install.packages("dplyr")
library(dplyr)
raw_elections_data <-
  read_csv(
    file = "canadian_voting.csv",
    show_col_types = FALSE
  )

cleaned_elections_data <-
  clean_names(raw_elections_data)

# Have a look at the first six rows
head(cleaned_elections_data)


cleaned_elections_data <-
  cleaned_elections_data |>
  select(
    electoral_district_name_nom_de_circonscription,
    elected_candidate_candidat_elu
  )
names(cleaned_elections_data)
head(cleaned_elections_data)


cleaned_elections_data <-
  cleaned_elections_data |>
  rename(
   col = elected_candidate,
   into = c("Other", "party"),
   sep = "/"
  ) |>
  select(-Other)

cleaned_elections_data <-
  cleaned_elections_data |>
  rename(
    division = division_nm,
    elected_party = party_nm
  )

head(cleaned_elections_data)
unique()
cleaned_elections_data <-
  cleaned_elections_data |>
  mutate(
    elected_party =
      case_match(
        elected_party,
        "Australian Labor Party" ~ "Labor",
        "Liberal National Party of Queensland" ~ "Liberal",
        "Liberal" ~ "Liberal",
        "The Nationals" ~ "Nationals",
        "The Greens" ~ "Greens",
        "Independent" ~ "Other",
        "Katter's Australian Party (KAP)" ~ "Other",
        "Centre Alliance" ~ "Other"
      )
  )

head(cleaned_elections_data)

cleaned_elections_data <-
  cleaned_elections_data <-
  read_csv(
    file = "cleaned_elections_data.csv",
    show_col_types = FALSE
  )

cleaned_elections_data |>
  count(elected_party)

cleaned_elections_data |>
  ggplot(aes(x = elected_party)) + # aes abbreviates "aesthetics" 
  geom_bar()

cleaned_elections_data |>
  ggplot(aes(x = elected_party)) +
  geom_bar() +
  theme_minimal() + # Make the theme neater
  labs(x = "Party", y = "Number of seats") # Make labels more meaningful