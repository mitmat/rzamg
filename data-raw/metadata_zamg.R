## code to prepare metadata_* datasets goes here

library(rzamg)
library(dplyr)



# station -----------------------------------------------------------------


metadata_station <- datasets_zamg %>%
    filter(type == "station", mode == "historical") %>%
    split(.$resource_id) %>%
    purrr::map(~ get_metadata_station(create_url(.x$type, .x$mode, .x$resource_id)))

usethis::use_data(metadata_station, overwrite = TRUE)



# grid --------------------------------------------------------------------



# not working (as of 2022-09-26)
to_remove <- c("apolis_long-v1-1d-100m",
               "apolis_short-v1-15min-100m",
               "inca-v1-10min-1km",
               "inca-v1-15min-1km",
               "inca-v1-1d-1km",
               "snowgrid_cl-v1-1d-1km",
               "spartacus-v2-1d-1km",
               "spartacus-v2-1m-1km",
               "winfore-v2-1d-1km")

metadata_grid <- datasets_zamg %>%
    filter(type == "grid",
           response_formats == "netcdf", # only one for meta
           ! resource_id %in% to_remove) %>%
    split(.$resource_id) %>%
    purrr::map(~ get_metadata_grid(create_url(.x$type, .x$mode, .x$resource_id)))


usethis::use_data(metadata_grid, overwrite = TRUE)
