
#' Get race meet meta data for specific race meet
#'
#' Internal function to return mrace meet meta data for a single date
#'
#' @param each_date date in YYYY-MM-DD format
#'
#' @return returns a dataframe of race meet data for single date
#'
#' @importFrom magrittr %>%
#'
#' @noRd
#'
.each_race_date <- function(each_date) {

  each_url <- paste0('https://api.beta.tab.com.au/v1/historical-results-service/VIC/racing/', each_date)

  history <- httr::RETRY("GET",
                         url = each_url,
                         times = 5, # the function has other params to tweak its behavior
                         pause_min = 5,
                         pause_base = 2)

  history_content <- suppressMessages(tryCatch(httr::content(history, "text"), error = function(e) NA_character_))

  meetings_list <- tryCatch(data.frame(jsonlite::fromJSON(history_content)$meetings), error = function(e) NA_character_)

  # need a while loop here as there were still times when the API was failing and returning a list of length zero
  # have arbitrarily set the max number of retries in the while-loop to 20 - might want to parameterise this later
  iter <- 1
  while(length(history_content) == 0 | is.na(history_content) | any(grepl("NOT_FOUND_ERROR", history_content))) {

    iter <- iter + 1
    stopifnot("The API is not accepting this request. Please try again." = iter <21)

    Sys.sleep(2)

    history <- httr::RETRY("GET",
                           url = each_url,
                           times = 5, # the function has other params to tweak its behavior
                           pause_min = 5,
                           pause_base = 2)


    history_content <- suppressMessages(tryCatch(httr::content(history, "text"), error = function(e) NA_character_))

    meetings_list <- tryCatch(data.frame(jsonlite::fromJSON(history_content)$meetings), error = function(e) NA_character_)

  }

  return(meetings_list)
}



#' Get race meet metadata
#'
#' Returns race meet details for selected date(s)
#'
#' @param race_dates vector of dates in YYYY-MM-DD format
#'
#' @return returns a dataframe of all race meet metadata
#'
#' @importFrom magrittr %>%
#'
#' @export
#'
#' @examples
#' \dontrun{
#' try({
#' dates <- seq(from = as.Date("2022-08-01"), to=as.Date("2022-08-03"), by=1)
#' df <- get_race_meet_meta(race_dates=dates)
#' })
#' }
get_race_meet_meta <- function(race_dates) {

  race_dates %>%
    purrr::map_df(.each_race_date)
}


