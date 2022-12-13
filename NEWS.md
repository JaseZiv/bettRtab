# bettRtab  (development version)

### New Functions

* `load_race_meet_meta()` to load in pre-scraped race meet meta data
* `get_past_race_content()` to get past race content using URLs
* `get_past_races()` to get past race content using paremeters
* `parse_runners()` to extract runners and betting markets from the output of `get_past_race_content()` and `get_past_races()`
* `parse_pools()` to extract betting pools from the output of `get_past_race_content()` and `get_past_races()`
* `parse_dividends()` to extract dividends from the output of `get_past_race_content()` and `get_past_races()`
* `get_race_meet_meta()` to get metadata from race meets from selected date(s)
* `get_sports_market()` to get the betting markets for a selected competition
* `get_live_sports()` to get in-play (live) sports markets (0.0.0.7000)


### Bugs

* `get_race_meet_meta()` not retrying when content returned is empty ("") (0.0.0.8000)
