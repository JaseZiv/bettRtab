
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bettRtab <img src="man/figures/logo.png" align="right" width="181" height="201"/>

<!-- badges: start -->

[![Version-Number](https://img.shields.io/github/r-package/v/JaseZiv/bettRtab?label=bettRtab%20(Dev))](https://github.com/JaseZiv/bettRtab/)
[![R build
status](https://github.com/JaseZiv/bettRtab/workflows/R-CMD-check/badge.svg)](https://github.com/JaseZiv/bettRtab/actions)
<!-- badges: end -->

## Overview

This package is designed to allow users to obtain clean and tidy
[TAB](https://www.tab.com.au/) betting markets for both racing and
sports. It gives users the ability to access data more efficiently.

### Future Plans

I hope to expand this to allow for interacting with the betting API -
potentially giving users the ability to place bets through the API. To
do this, I’m still waiting on the TAB Digital Team to respond to a
request for an access token to be able to test out some functions.

------------------------------------------------------------------------

## Installation

You can install the released version of
[**`bettRtab`**](https://github.com/JaseZiv/bettRtab/) from
[GitHub](https://github.com/JaseZiv/bettRtab) with:

``` r
# install.packages("remotes")
remotes::install_github("JaseZiv/bettRtab")
library(bettRtab)
```

## Usage

The functions in this package should work without hitch locally, but
running these in an automated way (GitHub Actions, cloud, etc) may lead
to requests being blocked.

To get around this, you will need access to proxies and would need to
set configs at the start of your scripts similar to the following:

``` r
httr::set_config(httr::use_proxy(url = Sys.getenv("PROXY_URL"),
                                 port = as.numeric(Sys.getenv("PROXY_PORT")),
                                 username =Sys.getenv("PROXY_USERNAME"),
                                 password= Sys.getenv("PROXY_PASSWORD")))
```

### How To

To get a better understanding of how to use the library, see the package
vignette
[here](https://jaseziv.github.io/bettRtab/articles/using-bettRtab.html)

------------------------------------------------------------------------

## Show your support

Follow me on Twitter ([jaseziv](https://twitter.com/jaseziv)) for
updates

If this package helps you, all I ask is that you star this repo. If you
did want to show your support and contribute to server time and data
storage costs, feel free to send a small donation through the link
below.

<a href="https://www.buymeacoffee.com/jaseziv83A" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Coffee (Server Time)" height="41" width="174"></a>

------------------------------------------------------------------------

## Contributing

### Issues and Improvements

When creating an issue, please include:

- Reproducible examples
- A brief description of what the expected results are
- For improvement suggestions, what features are being requested and
  their purpose

Feel free to get in touch via email or twitter
<https://twitter.com/jaseziv> if you aren’t able to create an issue.

------------------------------------------------------------------------

## Acknowledgement

Image used in the logo comes from
[shutterstock](https://www.shutterstock.com/search/betting-paper)
