
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
