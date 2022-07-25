## code to prepare `metadata_zamg` dataset goes here

library(rzamg)
library(dplyr)

metadata_zamg <- datasets_zamg %>%
    filter(startsWith(resource_id, "klim")) %>%
    split(.$resource_id) %>%
    purrr::map(~ get_metadata(resource_id = .x$resource_id))


usethis::use_data(metadata_zamg, overwrite = TRUE)
