

get_sports_market <- function(competition_name) {
  sports <- readRDS("data/sports_markets.rds")

  link_url <- sports %>%
    dplyr::filter(competitions.name == "NBA") %>%
    dplyr::pull(self) %>% unlist()


  res <-  httr::GET(link_url) %>% httr::content()

  aa <- res$matches

  markets_df <- data.frame()

  for(j in 1:length(aa)) {

    markets <- aa[[j]]$markets %>% jsonlite::toJSON() %>% jsonlite::fromJSON() %>% data.frame()
    markets <- markets %>%
      dplyr::rename(marketId=id, marketName=name, marketBettingStatus=bettingStatus, marketAllowPlace=allowPlace)

    df <- tidyr::unnest(markets, cols = propositions) %>% data.frame()

    markets_df <- dplyr::bind_rows(markets_df, df)

  }

  return(markets_df)
}



