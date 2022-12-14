% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_race_meets.R
\name{get_race_meet_meta}
\alias{get_race_meet_meta}
\title{Get race meet metadata}
\usage{
get_race_meet_meta(race_dates)
}
\arguments{
\item{race_dates}{vector of dates in YYYY-MM-DD format}
}
\value{
returns a dataframe of all race meet metadata
}
\description{
Returns race meet details for selected date(s)
}
\examples{
\dontrun{
try({
dates <- seq(from = as.Date("2022-08-01"), to=as.Date("2022-08-03"), by=1)
df <- get_race_meet_meta(race_dates=dates)
})
}
}
