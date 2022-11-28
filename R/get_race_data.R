#' Get each past race content (with URL)
#'
#' Returns a list of a race's data including runners, markets, dividends and pools
#' Internal function for  \code{get_past_race_content}
#'
#' @param url API url as character for the race needed
#'
#' @return returns a list of a race's data including runners, markets, dividends and pools
#'
#' @importFrom magrittr %>%
#'
#' @noRd
#'
.get_each_past <- function(url) {
  Sys.sleep(1)
  resp <- httr::RETRY("GET",
                      url = url,
                      times = 5, # the function has other params to tweak its behavior
                      pause_min = 5,
                      pause_base = 2) %>%
    httr::content(as = "text", encoding = "UTF-8")

  # need a while loop here as there were still times when the API was failing and returning a list of length zero
  # have arbitrarily set the max number of retries in the while-loop to 20 - might want to parameterise this later
  iter <- 0

  while(resp == "") {

    iter <- iter + 1
    stopifnot("The API is not accepting this request. Please try again." = iter <21)

    Sys.sleep(1)
    resp <- httr::RETRY("GET",
                        url = url,
                        times = 5, # the function has other params to tweak its behavior
                        pause_min = 5,
                        pause_base = 2) %>%
      httr::content(as = "text", encoding = "UTF-8")
  }

  resp <- resp %>%
    jsonlite::fromJSON()

  return(resp)
}

#' Get past race content (with URL)
#'
#' Returns a list of a race's data including runners, markets, dividends and pools
#' Can either use this function and provide it the race API URL, or use \code{get_past_races}
#' to get the same results. Note this can return results for multiple race meet URL at a time.
#' See the vignette or example for more details on how to get race API URLs.
#' Can then use the parsing functions to get the data you want from these lists.
#'
#' @param urls API url as character for the race needed
#'
#' @return returns a list of a race's data including runners, markets, dividends and pools
#'
#' @importFrom magrittr %>%
#'
#' @export
#'
#' @examples
#' \dontrun{
#' try({
#' # first load in meet data
#' meets <- bettRtab::load_race_meet_meta(2022)
#'
#' # then filter to the race(s) meets wanted
#' meet_dates_df <- meets %>%
#'   filter(venueMnemonic == "M",
#'          raceType == "R",
#'          meetingDate == "2022-01-01")
#'
#'  # then get the URLs
#' meet_url <- meet_dates_df$races[[1]]
#' meet_url <- meet_url$`_links`$self[1]
#'
#' out <- get_past_race_content(urls=meet_url)
#' })
#' }
get_past_race_content <- function(urls) {

  out <- urls %>%
    purrr::map(.get_each_past)

  return(out)
}



#' Get past race content
#'
#' Returns a list of a race or many races data including runners, markets, dividends and pools
#' Can either use this function and provide it the race API URL, or use \code{get_past_races}
#' to get the same results. Note this can return results for many race meets.
#' Can then use the parsing functions to get the data you want from these lists.
#'
#' @param meet_date race meet date in 'YYYY-MM-DD' format
#' @param venue_mnem the mnemonic of the track
#' @param race_type the type of race, either R, H, G
#' @param race_num integer if the race number. If null,  then all races for meet(s) returned
#'
#' @return returns a list of a race's data including runners, markets, dividends and pools
#'
#' @importFrom magrittr %>%
#'
#' @export
#'
#' @examples
#' \dontrun{
#' try({
#' out <- get_past_races(meet_date = c('2022-09-03', '2022-09-10'),
#'                      venue_mnem = 'M', race_type = 'R')
#' })
#' }
get_past_races <- function(meet_date, venue_mnem, race_type, race_num=NULL) {

  yrs <- lubridate::year(lubridate::ymd(meet_date)) %>% unique()


  dat_df <- yrs %>% purrr::map_df(load_race_meet_meta)


  df <- dat_df %>%
    dplyr::filter(.data[["meetingDate"]] %in% meet_date,
           .data[["venueMnemonic"]] %in% venue_mnem,
           .data[["raceType"]] %in% race_type)

  if(is.null(race_num)) {
    df <- dplyr::bind_rows(df$races) %>% data.frame()
  } else {
    df <- dplyr::bind_rows(df$races) %>% data.frame() %>% dplyr::filter(.data[["raceNumber"]] %in% race_num)
  }


  urls <- dplyr::pull(df$X_links)

  out <- urls %>%
    purrr::map(.get_each_past)

  return(out)

}
