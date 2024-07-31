
#' Replace Empty Values
#'
#' Returns a NA character for empty values
#'
#' @param val a value that can either be empty, or not empty
#'
#' @return NA_character where the extracted value is empty, or the value itself
#' @noRd
#'
.replace_empty_na <- function(val) {
  if(length(val) == 0) {
    val <- NA_character_
  } else {
    val <- val
  }
  return(val)
}



#' Unlist data frame columns
#'
#' Returns a data frame of character variables
#'
#' @param data data frame that has some list type columns
#'
#' @return a data frame of character variables
#' @noRd
#'
.unlist_df_cols <- function(data) {
  df_name <- names(data)

  ListCols <- sapply(data, is.list)
  data <- cbind(data[!ListCols], t(apply(data[ListCols], 1, as.character)))
  colnames(data) <- df_name
  return(data)
}



#' Read in stored RDS data
#'
#' Reads in RDS stored data files typically stored on GitHub
#'
#' @param file_url URL to RDS file(s) for reading in
#'
#' @return data type dependent on RDS file being read in
#' @noRd
#'
.file_reader <- function(file_url) {
  tryCatch(readRDS(url(file_url)), error = function(e) data.frame()) %>%
    suppressWarnings()
}


#' GET with specified user agent
#'
#' GET a URL, but with a pre-specified user agent
#'
#' @param url Uthe url of the page to retrieve
#'
#' @noRd
#'
.RETRY_GET_tab <- function(url) {

  headers = c(
    `User-Agent` = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
  )

  res <-  httr::RETRY("GET",
                      config = httr::add_headers(.headers=headers),
                      url = url,
                      times = 5, # the function has other params to tweak its behavior
                      pause_min = 5,
                      pause_base = 2)
}



