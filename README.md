**[development version to be used at own risk]**

## Overview

An R-package to access the [data hub](https://data.hub.zamg.ac.at/) of the central weather service of Austria ([ZAMG](https://www.zamg.ac.at/)).

Inspired by the great [rdwd](https://github.com/brry/rdwd) package.

Allows a programmatic retrieval of data, currently only supports station time series. The main functions for single requests are `create_url()` and `data_from_url()`, while `single_series()` and `batch_download()` provide a fast way to download larger batches.


## Installation

To install, use devtools:

```{r}
# if not already installed
# install.packages("devtools")

devtools::install_github("mitmat/rzamg")

```


## Contribute

Contributions and ideas are welcome! Feel free to reach out in any way.


## TODO:
- add check for internet connection?
- add ehyd/hzb crawler (separate package!)
