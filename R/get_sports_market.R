

get_sports_market <- function(competition_name) {
  sports <- readRDS("data/sports_markets.rds")

  link_url <- sports %>%
    dplyr::filter(competitions.name == competition_name) %>%
    dplyr::pull(self) %>% unlist()


  res <-  httr::GET(link_url) %>% httr::content()

  aa <- res$matches

  markets_df <- data.frame()

  for(j in 1:length(aa)) {

    markets <- aa[[j]]$markets %>% jsonlite::toJSON() %>% jsonlite::fromJSON() %>% data.frame()
    markets <- markets %>%
      dplyr::rename(marketId=id, marketName=name, marketBettingStatus=bettingStatus, marketAllowPlace=allowPlace)

    if(any(grep("sameGame", names(markets)))) {
      markets <- markets %>%
        dplyr::rename(marketSameGame=sameGame)
    }

    df <- tidyr::unnest(markets, cols = propositions) %>% data.frame()

    markets_df <- dplyr::bind_rows(markets_df, df)

  }

  return(markets_df)
}




dat <- get_sports_market("Major League Baseball")

dat_future <- get_sports_market("Major League Baseball Futures")


zz <- bind_rows(dat, dat_future)

.unlist_df_cols <- function(data) {
  ListCols <- sapply(data, is.list)
  cbind(data[!ListCols], t(apply(data[ListCols], 1, unlist)))
}


xx <- .unlist_df_cols(dat_future)



