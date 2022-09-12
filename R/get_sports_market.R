
#' Get all markets fr selected competition
#'
#' Returns all betting markets data for a selected TAB competition
#'
#' @param competition_name the name of the TAB competition. Found under the competitions page selector
#'
#' @return returns a dataframe of bets available for the selcted competition
#'
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#'
#' @export
#'
#' @examples
#' \dontrun{
#' try({
#' df <- get_sports_market("Major League Baseball Futures")
#' })
#' }
get_sports_market <- function(competition_name) {
  sports <- .file_reader("https://github.com/JaseZiv/Betting-Data/blob/main/data/sports_markets.rds?raw=true")

  link_url <- sports %>%
    dplyr::filter(.data$competitions.name == competition_name) %>%
    dplyr::pull(.data$self) %>% unlist()


  res <-  httr::GET(link_url) %>% httr::content()

  aa <- res$matches

  markets_df <- data.frame()

  for(j in 1:length(aa)) {

    markets <- aa[[j]]$markets %>% jsonlite::toJSON() %>% jsonlite::fromJSON() %>% data.frame()
    markets <- markets %>%
      dplyr::rename(marketId=.data$id, marketName=.data$name, marketBettingStatus=.data$bettingStatus, marketAllowPlace=.data$allowPlace)

    if(any(grep("sameGame", names(markets)))) {
      markets <- markets %>%
        dplyr::rename(marketSameGame=.data$sameGame)
    }

    df <- tidyr::unnest(markets, cols = .data$propositions) %>% data.frame()
    df <- df %>% dplyr::select(-.data$differential, -.data$message, -.data$informationMessage)
    df <- .unlist_df_cols(df)

    markets_df <- dplyr::bind_rows(markets_df, df)



  }

  return(markets_df)
}
