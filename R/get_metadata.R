#' Download metadata from ZAMG API
#'
#' Mostly for internal use, since the output is already available as
#' internal data sets: \code{\link{datasets_zamg}} and  \code{\link{metadata_zamg}}.
#'
#' A list of available data sets (with resource_id) can also be retrieved
#' from \url{http://dataset.api.hub.zamg.ac.at/v1/datasets/}.
#'
#'
#' @param type Data type, currently, pkg is only tested with "station" (default).
#' @param mode Data mode, currently, pkg is only tested with "historical" (default).
#' @param resource_id The resource_id.
#'
#' @return A list with two elements, the first a tibble of parameter information,
#'   the second with station information.
#'
#' @export
#'
#' @examples
#' \dontrun{
#'
#' get_metadata(resource_id = "klima-v1-10min")
#'
#' }
#'
get_metadata <- function(type = "station",
                         mode = "historical",
                         resource_id){

    # fixed parameters
    baseurl <- "https://dataset.api.hub.zamg.ac.at"
    version  <- "v1" # only v1 as of 2022-07-13

    checkmate::assert_choice(type, datasets_zamg$type)
    checkmate::assert_choice(mode, datasets_zamg$mode)
    checkmate::assert_choice(resource_id, datasets_zamg$resource_id)

    url_full <- paste(c(baseurl, version, type, mode, resource_id, "metadata"), collapse = "/")

    res <- httr::GET(url_full)
    if(httr::http_error(res)){
        stop(httr::content(res)$detail)
    }

    json <- httr::content(res)

    list(parameters = json$parameters %>% dplyr::bind_rows(),
         stations = json$stations %>%
             dplyr::bind_rows() %>%
             dplyr::mutate(valid_from = lubridate::ymd_hms(valid_from),
                           valid_to = lubridate::ymd_hms(valid_to)))

}
