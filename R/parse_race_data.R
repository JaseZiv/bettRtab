
#' Parse each race metadata
#'
#' Returns a data frame of a race's metadata
#' An internal function used to parse race lists from \code{get_past_race_content}
#' or \code{get_past_races}
#'
#' @param race_list_element list element output from \code{get_past_race_content} or \code{get_past_races}
#'
#' @return data frame of race metadata
#' @noRd
#'
.parse_race_meta <- function(race_list_element) {

  meeting <- race_list_element$meeting %>% data.frame()
  meeting <- meeting %>% dplyr::select(-dplyr::contains("sellCode"))


  meta <- data.frame(
    raceNumber=tryCatch(as.character(race_list_element[["raceNumber"]]) %>% .replace_empty_na(), error = function(e) NA_character_),
    raceName=tryCatch(as.character(race_list_element[["raceName"]]) %>% .replace_empty_na(), error = function(e) NA_character_),
    raceStartTime=tryCatch(as.character(race_list_element[["raceStartTime"]]) %>% .replace_empty_na(), error = function(e) NA_character_),
    raceStatus=tryCatch(as.character(race_list_element[["raceStatus"]]) %>% .replace_empty_na(), error = function(e) NA_character_),
    raceDistance=tryCatch(as.character(race_list_element[["raceDistance"]]) %>% .replace_empty_na(), error = function(e) NA_character_),
    resultedTime=tryCatch(as.character(race_list_element[["resultedTime"]]) %>% .replace_empty_na(), error = function(e) NA_character_),
    substitute=tryCatch(as.character(race_list_element[["substitute"]]) %>% .replace_empty_na(), error = function(e) NA_character_),
    raceClassConditions=tryCatch(as.character(race_list_element[["raceClassConditions"]]) %>% .replace_empty_na(), error = function(e) NA_character_),
    winBook=tryCatch(as.character(race_list_element[["winBook"]]) %>% .replace_empty_na(), error = function(e) NA_character_),
    scratchings=tryCatch(as.character(race_list_element[["scratchings"]][["runnerNumber"]] %>% paste(collapse = ",")) %>% .replace_empty_na(), error = function(e) NA_character_),
    skyRacingAudio=tryCatch(as.character(race_list_element[["skyRacing"]][["audio"]]) %>% .replace_empty_na(), error = function(e) NA_character_)
  )

  meta <- dplyr::bind_cols(meeting, meta)

  return(meta)
}



#' Parse each race runners
#'
#' Returns a data frame for race's runners
#' An internal function used by \code{parse_runners}
#'
#' @param race_list_element list element output from \code{get_past_race_content} or \code{get_past_races}
#'
#' @return data frame of a race's runners
#' @noRd
#'
.parse_runners_each_race <- function(race_list_element) {

  meta <- .parse_race_meta(race_list_element)

  runners <- tryCatch(race_list_element$runners %>% data.frame(), error = function(e) data.frame())
  runners <- tryCatch(tidyr::unnest(runners, cols = c(.data$fixedOdds, .data$parimutuel), names_sep = "."), error = function(e) data.frame())

  df <- dplyr::bind_cols(meta, runners)

  return(df)
}



#' Parse race runners
#'
#' Returns a data frame of a race's runners and betting odds
#' A function used to parse output race lists from \code{get_past_race_content}
#' or \code{get_past_races}
#'
#' @param race_list output from \code{get_past_race_content} or \code{get_past_races}
#'
#' @return returns a dataframe of all race meet runners
#'
#' @importFrom magrittr %>%
#'
#' @export
#'
#' @examples
#' \dontrun{
#' try({
#' races <- get_race_data(meet_date="2022-09-03", venue_mnem="M", race_type="R", race_num=NULL)
#' df <- parse_runners(race_list=races)
#' })
#' }
parse_runners <- function(race_list) {
  race_list %>%
    purrr::map_df(.parse_runners_each_race)
}




#' Parse each race pools
#'
#' Returns a data frame for race's betting pools
#' An internal function used by \code{parse_pools}
#'
#' @param race_list_element list element output from \code{get_past_race_content} or \code{get_past_races}
#'
#' @return data frame of a race's belling pool
#' @noRd
#'
.parse_pools_each_race <- function(race_list_element) {

  meta <- .parse_race_meta(race_list_element)

  pools <- tryCatch(race_list_element$pools %>% tidyr::unnest(.data$legs), error = function(e) data.frame())

  pools <- pools %>% dplyr::select(-dplyr::matches("raceType|venueMnemonic|raceNumber", perl=TRUE))

  pools <- dplyr::bind_cols(meta, pools)

  return(pools)
}



#' Parse race betting pools
#'
#' Returns a data frame of a race's betting pools
#' A function used to parse output race lists from \code{get_past_race_content}
#' or \code{get_past_races}
#'
#' @param race_list output from \code{get_past_race_content} or \code{get_past_races}
#'
#' @return returns a dataframe of all race meet betting pools
#'
#' @importFrom magrittr %>%
#'
#' @export
#'
#' @examples
#' \dontrun{
#' try({
#' races <- get_race_data(meet_date="2022-09-03", venue_mnem="M", race_type="R", race_num=NULL)
#' df <- parse_pools(race_list=races)
#' })
#' }
parse_pools <- function(race_list) {
  race_list %>%
    purrr::map_df(.parse_pools_each_race)
}




#' Parse each race dividends
#'
#' Returns a data frame for race's dividends
#' An internal function used by \code{parse_dividends}
#'
#' @param race_list_element list element output from \code{get_past_race_content} or \code{get_past_races}
#'
#' @return data frame of a race's dividends
#' @noRd
#'
.parse_dividends_each_race <- function(race_list_element) {

  meta <- .parse_race_meta(race_list_element)
  dividends <- tryCatch(race_list_element$dividends %>% tidyr::unnest(.data$poolDividends), error = function(e) data.frame())

  dividends <- dplyr::bind_cols(meta, dividends)
  return(dividends)
}



#' Parse race betting dividends
#'
#' Returns a data frame of a race's betting dividends
#' A function used to parse output race lists from \code{get_past_race_content}
#' or \code{get_past_races}
#'
#' @param race_list output from \code{get_past_race_content} or \code{get_past_races}
#'
#' @return returns a dataframe of race betting dividends
#'
#' @importFrom magrittr %>%
#'
#' @export
#'
#' @examples
#' \dontrun{
#' try({
#' races <- get_race_data(meet_date="2022-09-03", venue_mnem="M", race_type="R", race_num=NULL)
#' df <- parse_dividends(race_list=races)
#' })
#' }
parse_dividends <- function(race_list) {
  race_list %>%
    purrr::map_df(.parse_dividends_each_race)
}

