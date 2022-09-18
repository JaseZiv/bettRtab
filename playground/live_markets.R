


# a <- httr::RETRY("GET", "https://api.beta.tab.com.au/v1/recommendation-service/live-events?jurisdiction=VIC")
#
# check_status <- function(res) {
#
#   x = httr::status_code(res)
#
#   if(x != 200) stop("The API returned an error", call. = FALSE)
#
# }
# # Check the result
# check_status(a)
#
# b <- a %>%
#   httr::content(as = "text", encoding = "UTF-8")
# c <- jsonlite::fromJSON(b)




get_content <- function(target_url) {

  res <- httr::RETRY("GET",
                         url = target_url,
                         times = 5, # the function has other params to tweak its behavior
                         pause_min = 5,
                         pause_base = 2)

  resp <- suppressMessages(tryCatch(httr::content(res, "text"), error = function(e) NA_character_))

  meetings_list <- tryCatch(data.frame(jsonlite::fromJSON(history_content)$meetings), error = function(e) NA_character_)

  # need a while loop here as there were still times when the API was failing and returning a list of length zero
  # have arbitrarily set the max number of retries in the while-loop to 20 - might want to parameterise this later
  iter <- 1
  while(length(history_content) == 0 | is.na(history_content) | any(grepl("NOT_FOUND_ERROR", history_content))) {

    iter <- iter + 1
    stopifnot("The API is not accepting this request. Please try again." = iter <21)

    Sys.sleep(2)

    res <- httr::RETRY("GET",
                           url = target_url,
                           times = 5, # the function has other params to tweak its behavior
                           pause_min = 5,
                           pause_base = 2)


    history_content <- suppressMessages(tryCatch(httr::content(res, "text"), error = function(e) NA_character_))

    meetings_list <- tryCatch(data.frame(jsonlite::fromJSON(history_content)$meetings), error = function(e) NA_character_)

  }
}





library(httr)
library(tidyverse)


params = list(
  `jurisdiction` = 'VIC'
)

res <- httr::GET(url = 'https://api.beta.tab.com.au/v1/recommendation-service/live-events-summary', query = params)

resp <- content(res)


z <- jsonlite::fromJSON("https://api.beta.tab.com.au/v1/recommendation-service/live-events?jurisdiction=VIC")

res <- httr::RETRY("GET",
                   url = "https://api.beta.tab.com.au/v1/recommendation-service/live-events?jurisdiction=VIC",
                   times = 5, # the function has other params to tweak its behavior
                   pause_min = 5,
                   pause_base = 2)

resp <- suppressMessages(tryCatch(httr::content(res, "text"), error = function(e) NA_character_))


resp <- jsonlite::fromJSON(resp)


# resp <- jsonlite::fromJSON("https://api.beta.tab.com.au/v1/recommendation-service/live-events?jurisdiction=VIC")


sports <- resp$liveMatches$sports

dat <- sports %>% unnest(competitions, names_sep = ".")
idx <- mapply(length, dat$competitions.tournaments)
idx <- idx>0



non_tennis <- dat[!idx,]
non_tennis <- non_tennis %>%
  select(-competitions.betOptionPriority, -competitions.tournaments, -count)


non_tennis_matches <- non_tennis %>%
  unnest(competitions.matches, names_sep = ".")

non_tennis_matches <- non_tennis_matches %>%
  select(id, name, displayName, competitions.id, competitions.name, competitions.matches.id, competitions.matches.name, competitions.matches.spectrumUniqueId,
         contains("Time"), -contains("vision"), competitions.matches.markets)


non_tennis_markets <- non_tennis_matches %>%
  unnest(competitions.matches.markets, names_sep = ".")

non_tennis_proposiotions <- non_tennis_markets %>%
  unnest(competitions.matches.markets.propositions, names_sep = ".")




tennis <- dat[idx,]


tennis <- tennis %>%
  select(-competitions.betOptionPriority, -competitions.matches, -count)
names(tennis) <- gsub(".tournaments", ".matches", names(tennis))

tennis_matches <- tennis %>%
  unnest(competitions.matches, names_sep = ".")


testing <- jsonlite::fromJSON("https://api.beta.tab.com.au/v1/tab-info-service/sports/Tennis/competitions/Challenger/tournaments/Challenger%20Cary/matches/Kudla%20v%20Koepfer/markets?jurisdiction=VIC")



non_tennis_matches <- non_tennis_matches %>%
  select(id, name, displayName, competitions.id, competitions.name, competitions.matches.id, competitions.matches.name, competitions.matches.spectrumUniqueId,
         contains("Time"), -contains("vision"), competitions.matches.markets)


non_tennis_markets <- non_tennis_matches %>%
  unnest(competitions.matches.markets, names_sep = ".")

non_tennis_proposiotions <- non_tennis_markets %>%
  unnest(competitions.matches.markets.propositions, names_sep = ".")







tennis <- tennis %>% select(-starts_with("competitions.matches"))
names(tennis) <- gsub(".tournaments", ".matches", names(tennis))

tennis_matches <- tennis %>%
  unnest(competitions.tournaments, names_sep = ".") %>%
  unnest(competitions.tournaments.matches, names_sep = ".") %>%
  unnest(competitions.tournaments.matches.markets, names_sep = ".")


# dat2 <- dat %>% unnest(competitions.matches, names_sep = ".")
# dat3 <- dat2 %>% unnest(competitions.matches.markets, names_sep = ".")



comps <- sports$competitions %>% bind_rows() %>%
  unnest(matches, names_sep = ".") %>%
  select(-contains("betOption"),
         -contains("competitors"),
         -contains("broadcast"),
         -contains("vision"))
#
# markets <- comps %>%
#   unnest(matches.markets, names_sep = ".")
#
#
# props <- markets %>% unnest(matches.markets.propositions, names_sep = ".")



df <- sports$competitions %>%
  bind_rows() %>%
  unnest(., names_sep = ".") %>%
  unnest(matches.markets, names_sep = ".") %>%
  unnest(matches.markets.propositions, names_sep = ".")






require(httr)



params = list(
  `jurisdiction` = 'VIC'
)

res <- httr::GET(url = 'https://api.beta.tab.com.au/v1/tab-info-service/racing/dates', query = params)
resp <- content(res)

today_races <- jsonlite::fromJSON("https://api.beta.tab.com.au/v1/tab-info-service/racing/dates/2022-09-16/meetings?jurisdiction=VIC")

race <- jsonlite::fromJSON("https://api.beta.tab.com.au/v1/tab-info-service/racing/dates/2022-09-16/meetings/G/RIC/races?jurisdiction=VIC")



