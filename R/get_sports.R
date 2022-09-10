require(httr)
library(jsonlite)
library(dplyr)


params = list(
  `jurisdiction` = 'VIC'
)

res <- httr::GET(url = 'https://api.beta.tab.com.au/v1/tab-info-service/sports', query = params)

a <- httr::content(res)
b <- a$sports

all_data <- data.frame()

for(i in b) {
  each_sport <- toJSON(i) %>% fromJSON() %>% data.frame()

  # z <- i$competitions
  # comps_in_sport <- z %>% toJSON() %>% fromJSON() %>% data.frame()

  all_data <- bind_rows(all_data, each_sport)
}

all_data <- all_data %>%
  select(-competitions.tournaments)

all_data <- tidyr::unnest(all_data,
                     cols = c(competitions.id, competitions.name, competitions.spectrumId,
                              competitions._links, competitions.hasMarkets,
                              competitions.sameGame))

saveRDS(all_data, "data/sports_markets.rds")



