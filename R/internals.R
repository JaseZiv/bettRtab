
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
  ListCols <- sapply(data, is.list)
  cbind(data[!ListCols], t(apply(data[ListCols], 1, unlist)))
}
