% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_race_data.R
\name{get_past_race_content}
\alias{get_past_race_content}
\title{Get past race content (with URL)}
\usage{
get_past_race_content(urls)
}
\arguments{
\item{urls}{API url as character for the race needed}
}
\value{
returns a list of a race's data including runners, markets, dividends and pools
}
\description{
Returns a list of a race's data including runners, markets, dividends and pools
Can either use this function and provide it the race API URL, or use \code{get_past_races}
to get the same results. Note this can return results for multiple race meet URL at a time.
See the vignette or example for more details on how to get race API URLs.
Can then use the parsing functions to get the data you want from these lists.
}
\examples{
\dontrun{
try({
# first load in meet data
meets <- bettRtab::load_race_meet_meta(2022)

# then filter to the race(s) meets wanted
meet_dates_df <- meets \%>\%
  filter(venueMnemonic == "M",
         raceType == "R",
         meetingDate == "2022-01-01")

 # then get the URLs
meet_url <- meet_dates_df$races[[1]]
meet_url <- meet_url$`_links`$self[1]

out <- get_past_race_content(urls=meet_url)
})
}
}
