**[development version to be used at own risk]**

## Overview

An R-package to access the [data hub](https://data.hub.zamg.ac.at/) of the central weather service of Austria ([ZAMG](https://www.zamg.ac.at/)).

Inspired by the great [rdwd](https://github.com/brry/rdwd) package.

Allows a programmatic retrieval of data, currently supports stations and grids. The main functions for single requests are `create_url()`, `query_station()`, `query_grid()`, together with `station_data()` and `grid_data()`, respectively. Batch download functionality is available via `station_batch()` and `grid_batch()`. Metadata is stored as package data: `metadata_station` and `metadata_grid`.


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

- output_format=csv works better for station -> rewrite station_batch/station_single?
- check for date parameter: is date, and within period available; -> might be already provided by datahub
- add check for max api request limit (1e6 values for csv/json) -> or not, since error is provided by datahub

