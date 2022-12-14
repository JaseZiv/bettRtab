% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/parse_race_data.R
\name{parse_dividends}
\alias{parse_dividends}
\title{Parse race betting dividends}
\usage{
parse_dividends(race_list)
}
\arguments{
\item{race_list}{output from \code{get_past_race_content} or \code{get_past_races}}
}
\value{
returns a dataframe of race betting dividends
}
\description{
Returns a data frame of a race's betting dividends
A function used to parse output race lists from \code{get_past_race_content}
or \code{get_past_races}
}
\examples{
\dontrun{
try({
races <- get_race_data(meet_date="2022-09-03", venue_mnem="M", race_type="R", race_num=NULL)
df <- parse_dividends(race_list=races)
})
}
}
