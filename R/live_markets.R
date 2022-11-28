
#' Get all in-play sports markets
#'
#' Returns all currently running in-play betting markets
#'
#'
#' @return returns a dataframe of all in-play bets available currently
#'
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#'
#' @export
#'
#' @examples
#' \dontrun{
#' try({
#' df <- get_live_sports()
#' })
#' }
get_live_sports <- function() {
  res <- httr::RETRY("GET",
                     url = "https://api.beta.tab.com.au/v1/recommendation-service/live-events?jurisdiction=VIC",
                     times = 5, # the function has other params to tweak its behavior
                     pause_min = 5,
                     pause_base = 2)

  resp <- suppressMessages(tryCatch(httr::content(res, "text"), error = function(e) NA_character_))

  # need a while loop here as there were still times when the API was failing and returning a list of length zero
  # have arbitrarily set the max number of retries in the while-loop to 20 - might want to parameterise this later
  iter <- 0

  while(resp == "" | is.na(resp)) {

    iter <- iter + 1
    stopifnot("The API is not accepting this request. Please try again." = iter <21)

    Sys.sleep(1)
    res <- httr::RETRY("GET",
                        url = "https://api.beta.tab.com.au/v1/recommendation-service/live-events?jurisdiction=VIC",
                        times = 5, # the function has other params to tweak its behavior
                        pause_min = 5,
                        pause_base = 2) %>%
      httr::content(as = "text", encoding = "UTF-8")

    resp <- suppressMessages(tryCatch(httr::content(res, "text"), error = function(e) NA_character_))
  }

  resp <- jsonlite::fromJSON(resp)

  sports <- resp$liveMatches$sports

  dat <- sports %>% tidyr::unnest(.data[["competitions"]], names_sep = ".")

  # if there are sports that have tournaments, then we need to treat them differently.
  # need to identify these"
  idx <- mapply(length, dat$competitions.tournaments)
  idx <- idx>0


  # # need to handle for non-tournaments in the following way:
  out <- dat[!idx,]

  out <- out %>%
    dplyr::select(-.data[["competitions.betOptionPriority"]], -.data[["competitions.tournaments"]], -.data[["count"]]) %>%
    tidyr::unnest(.data[["competitions.matches"]], names_sep = ".") %>%
    dplyr::select(.data[["id"]], .data[["name"]], .data[["displayName"]], .data[["competitions.id"]], .data[["competitions.name"]],
                  .data[["competitions.matches.id"]], .data[["competitions.matches.name"]], .data[["competitions.matches.spectrumUniqueId"]],
                  dplyr::contains("Time"), .data[["competitions.matches.markets"]]) %>%
    tidyr::unnest(.data[["competitions.matches.markets"]], names_sep = ".") %>%
    tidyr::unnest(.data[["competitions.matches.markets.propositions"]], names_sep = ".")

  # different way for handling tournaments - tennis has WTA as the comp,
  # then different tournaments under WTA, then matches - there is one more level of unnesting
  if(any(idx)) {

    tourn <- dat[idx,]

    tourn <- tourn %>%
      dplyr::select(-.data[["competitions.betOptionPriority"]], -.data[["competitions.matches"]], -.data[["count"]])

    # unnest to get the different tournaments:
    tourn_tournaments <- tourn %>%
      dplyr::select(.data[["competitions.id"]], .data[["competitions.tournaments"]]) %>%
      tidyr::unnest(.data[["competitions.tournaments"]], names_sep = ".") %>%
      dplyr::select(-dplyr::contains("betOptionPriority"))

    # now we need to join the two df created to have a meta df for the sports. This will be important as subsequent data frames
    # will have their names changed to remove the "tournament" element so they fit within the non-tournament sports
    tourn <- tourn %>%
      dplyr::left_join(tourn_tournaments, by = c("competitions.id")) %>%
      # then drop the column that's not needed as we've already expanded this in the previous step
      dplyr::select(-.data[["competitions.tournaments"]])


    # now unnest to get the list of live matches
    tourn_matches <- tourn_tournaments %>%
      dplyr::select(.data[["competitions.tournaments.id"]], .data[["competitions.tournaments.matches"]]) %>%
      tidyr::unnest(.data[["competitions.tournaments.matches"]], names_sep = ".") %>%
      dplyr::select(.data[["competitions.tournaments.id"]], dplyr::contains("Time"), .data[["competitions.tournaments.matches.markets"]])

    # change all these names so that we remove "tournaments" from them. This will mean we can append to our non-tournament data
    names(tourn_matches) <- gsub(".tournaments", "", names(tourn_matches))


    tourn <- tourn %>%
      dplyr::left_join(tourn_matches, by = c("competitions.tournaments.id" = "competitions.id")) %>%
      # then drop the column that's not needed as we've already expanded this in the previous step
      dplyr::select(-.data[["competitions.tournaments.matches"]]) %>%
      tidyr::unnest(.data[["competitions.matches.markets"]], names_sep = ".") %>%
      tidyr::unnest(.data[["competitions.matches.markets.propositions"]], names_sep = ".")



    out <- dplyr::bind_rows(out, tourn)

    out <- out %>%
      dplyr::select(.data[["id"]], .data[["name"]], .data[["displayName"]], .data[["competitions.id"]], .data[["competitions.name"]],
             .data[["competitions.tournaments.id"]], .data[["competitions.tournaments.name"]],
             dplyr::everything())

  }

  return(out)
}
