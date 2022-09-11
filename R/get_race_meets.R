library(httr)
library(rvest)
library(lubridate)
library(tidyverse)


# .replace_empty_na <- function(val) {
#   if(length(val) == 0) {
#     val <- NA_character_
#   } else {
#     val <- val
#   }
#   return(val)
# }


.each_race_date <- function(each_date) {

  each_url <- paste0('https://api.beta.tab.com.au/v1/historical-results-service/VIC/racing/', each_date)

  history <- httr::RETRY("GET",
                         url = each_url,
                         times = 5, # the function has other params to tweak its behavior
                         pause_min = 5,
                         pause_base = 2)

  # print(httr::http_status(history)$message)

  history <- history %>% content()

  # need a while loop here as there were still times when the API was failing and returning a list of length zero
  # have arbitrarily set the max number of retries in the while-loop to 20 - might want to parameterise this later
  iter <- 1
  while(length(history) == 0) {

    iter <- iter + 1
    stopifnot("The API is not accepting this request. Please try again." = iter <21)

    Sys.sleep(2)

    history <- httr::RETRY("GET",
                           url = each_url,
                           times = 5, # the function has other params to tweak its behavior
                           pause_min = 5,
                           pause_base = 2)

    history <- history %>% httr::content()

  }

  # history <- httr::GET(url = paste0('https://api.beta.tab.com.au/v1/historical-results-service/VIC/racing/', each_date)) %>% content()
  meetings_list <- history$meetings


  .each_race_meet <- function(x) {
    meta <- data.frame(meetingName = tryCatch(as.character(x[["meetingName"]]) %>% .replace_empty_na(), error = function(e) NA_character_),
                       location = tryCatch(as.character(x[["location"]]) %>% .replace_empty_na(), error = function(e) NA_character_),
                       venueMnemonic = tryCatch(as.character(x[["venueMnemonic"]]) %>% .replace_empty_na(), error = function(e) NA_character_),
                       raceType = tryCatch(as.character(x[["raceType"]]) %>% .replace_empty_na(), error = function(e) NA_character_),
                       meetingDate = tryCatch(as.character(x[["meetingDate"]]) %>% .replace_empty_na(), error = function(e) NA_character_),
                       weatherCondition = tryCatch(as.character(x[["weatherCondition"]]) %>% .replace_empty_na(), error = function(e) NA_character_),
                       trackCondition = tryCatch(as.character(x[["trackCondition"]]) %>% .replace_empty_na(), error = function(e) NA_character_),
                       meetUrl = tryCatch(as.character(x[["_links"]][["self"]]) %>% .replace_empty_na(), error = function(e) NA_character_),
                       numRaces = tryCatch(x$races %>% length() %>% .replace_empty_na(), error = function(e) NA_character_)
)
  }

  dat <- meetings_list %>%
    purrr::map_df(.each_race_meet)

}




get_race_meet_meta <- function(race_dates) {

  race_dates %>%
    purrr::map_df(.each_race_date)
}




dates <- seq(from = ymd("2021-01-01"), to=ymd("2022-09-03"), by=1) %>% as.character()

race_meets <- data.frame()


for(i in dates) {
  print(paste("scraping date:", i))
  # Sys.sleep(2)
  df <- get_race_meet_meta(i)
  race_meets <- bind_rows(race_meets, df)
}


saveRDS(race_meets, "data/race_meets_21_22.rds")


