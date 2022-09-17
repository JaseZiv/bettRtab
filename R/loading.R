#' Load race meet metadata
#'
#' Loading version of \code{get_race_meet_meta}
#' Returns all race meets meta data for a whole calendar year
#'
#' @param cal_year calendar year to get data for
#'
#' @return returns a dataframe all race meets meta data for a selected calendar year
#'
#' @importFrom magrittr %>%
#' @importFrom cli cli_alert
#'
#' @export
#'
#' @examples
#' \donttest{
#' try({
#' df <- load_race_meet_meta(cal_year=2022)
#' })
#' }
load_race_meet_meta <- function(cal_year) {
  dat_urls <- paste0("https://github.com/JaseZiv/Betting-Data/blob/main/data/race-meets/", cal_year, "/race_meets_meta_", cal_year, ".rds?raw=true")

  dat_df <- .file_reader(dat_urls)

  if(nrow(dat_df) == 0) {
    cli::cli_alert("Data not loaded. Please check parameters")
  } else {
    return(dat_df)
  }

}
