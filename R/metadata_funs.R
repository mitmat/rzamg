#' Download metadata from ZAMG API
#'
#' For internal use, since the output is already available as
#' internal data sets: \code{\link{datasets_zamg}} and  \code{\link{metadata_station}}.
#'
#' A list of available data sets (with resource_id) can also be retrieved
#' from \url{http://dataset.api.hub.zamg.ac.at/v1/datasets/}.
#'
#'
#' @param u URL from \code{\link{create_url}}.
#'
#' @return A list with two elements, the first a tibble of parameter information,
#'   the second with station/grid information.
#'
#' @import dplyr
#'
get_metadata_station <- function(u){

    url_full <- paste0(u, "/metadata")

    res <- httr::GET(url_full)

    if(httr::http_error(res)) stop(httr::content(res)$detail)
    if(httr::headers(res)$`content-type` != "application/json"){
        print(res)
        stop("No JSON received.")
    }

    json <- httr::content(res)

    list(parameters = json$parameters %>% dplyr::bind_rows(),
         stations = json$stations %>%
             bind_rows() %>%
             mutate(valid_from = lubridate::ymd_hms(valid_from),
                    valid_to = lubridate::ymd_hms(valid_to)))

}
#' @rdname get_metadata_station
get_metadata_grid <- function(u){

    url_full <- paste0(u, "/metadata")
    # print(url_full) # for checking

    res <- httr::GET(url_full)

    if(httr::http_error(res)) stop(httr::content(res)$detail)
    if(httr::headers(res)$`content-type` != "application/json"){
        print(res)
        stop("No JSON received.")
    }

    json <- httr::content(res)

    list(parameters = json$parameters %>% dplyr::bind_rows(),
         grid = json[c("title", "frequency", "start_time", "end_time", "spatial_resolution_m")] %>%
             as_tibble() %>%
             mutate(start_time = lubridate::ymd_hms(start_time),
                    end_time = lubridate::ymd_hms(end_time)) %>%
             bind_cols(stats::setNames(json$bbox, c("ymin", "xmin", "ymax", "xmax"))))

}

