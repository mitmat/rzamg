## code to prepare `datasets_zamg` dataset goes here

library(magrittr)

u <- "http://dataset.api.hub.zamg.ac.at/v1/datasets/"
jsonlite::fromJSON(u) %>%
    purrr::map(tibble::as_tibble) %>%
    dplyr::bind_rows(.id = "id") %>%
    tidyr::separate(id, c(NA, NA, NA, "resource_id"), sep = "/") -> datasets_zamg

usethis::use_data(datasets_zamg, overwrite = TRUE)
