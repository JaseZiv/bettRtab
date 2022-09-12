
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

## Installation

You can install the released version of
[**`bettRtab`**](https://github.com/JaseZiv/bettRtab/) from
[GitHub](https://github.com/JaseZiv/bettRtab) with:

``` r
# install.packages("remotes")
remotes::install_github("JaseZiv/bettRtab")
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

## Acknowledgement

Image used in the logo comes from
[shutterstock](https://www.shutterstock.com/search/betting-paper)
