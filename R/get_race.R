require(httr)



require(httr)

history <- httr::GET(url = 'https://api.beta.tab.com.au/v1/historical-results-service/VIC/racing/2022-08-27') %>% content()




library(httr)
library(rvest)
library(tidyverse)
library(jsonlite)

get_race_results <- function(race_num) {

  Sys.sleep(3)

  each_race <- httr::GET(paste0("https://api.beta.tab.com.au/v1/historical-results-service/VIC/racing/2022-08-27/M/R/races/", race_num)) %>% content()

  # get race meta data
  meeting <- each_race$meeting %>% bind_cols()

  meeting <- bind_cols(meeting,
                        raceNumber = each_race[["raceNumber"]],
                        raceName = each_race[["raceName"]],
                        raceStartTime = each_race[["raceStartTime"]],
                        raceStatus = each_race[["raceStatus"]],
                        raceDistance = each_race[["raceDistance"]]
                        )

  runners <- each_race$runners
  df <- data.frame()

  for(i in runners) {
    fo <- i$fixedOdds
    each <- within(i, rm(parimutuel, fixedOdds)) %>% bind_cols()
    each <- each %>% bind_cols(fo)

    df <- bind_rows(df, each)
  }

  df <- meeting %>% bind_cols(df)

  return(df)
}



out <- 1:9 %>%
  purrr::map_df(get_race_results)

saveRDS(out, "data/races_2022-08-27_m_r.rds")



