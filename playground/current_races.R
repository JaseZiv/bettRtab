


require(httr)



params = list(
  `jurisdiction` = 'VIC'
)

res <- httr::GET(url = 'https://api.beta.tab.com.au/v1/tab-info-service/racing/dates', query = params)
resp <- content(res)

today_races <- jsonlite::fromJSON("https://api.beta.tab.com.au/v1/tab-info-service/racing/dates/2022-09-16/meetings?jurisdiction=VIC")

race <- jsonlite::fromJSON("https://api.beta.tab.com.au/v1/tab-info-service/racing/dates/2022-09-16/meetings/G/RIC/races?jurisdiction=VIC")

