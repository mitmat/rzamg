#' Download a single time series of one parameter
#'
#' A streamlined combination of \code{\link{create_url}} and
#' \code{\link{data_from_url}} that only allows one station
#' and one parameter to be downloaded. Only returns the time
#' series without metadata.
#'
#' @param resource_id The resource_id as available in \code{\link{datasets_zamg}}.
#' @param parameter Parameter (character, length 1), might have different name depending on resource_id,
#'   see also \code{\link{metadata_zamg}}.
#' @param date_start The start date (ISO8601) to download the time series.
#' @param date_end The end date (ISO8601) to download the time series.
#' @param station_id Station identifier (character, length 1), see also \code{\link{metadata_zamg}}.
#' @param type Data type, currently, pkg is only tested with "station" (default).
#' @param mode Data mode, currently, pkg is only tested with "historical" (default).
#'
#' @return A tibble with columns datetime and value.
#'
#' @export
#'
#' @examples
#' single_series(resource_id = "klima-v1-10min",
#'               parameter = "RR",
#'               date_start = "2020-12-24T08:00",
#'               date_end = "2020-12-24T09:00",
#'               station_id = "5904")
#'
single_series <- function(resource_id,
                          parameter,
                          date_start,
                          date_end,
                          station_id,
                          type = "station",
                          mode = "historical"){
    # fixed parameters
    baseurl <- "https://dataset.api.hub.zamg.ac.at"
    version  <- "v1" # only v1 as of 2022-07-13

    checkmate::assert_choice(type, c("station", "grid", "timeseries"))
    checkmate::assert_choice(mode, c("historical", "current", "forecast"))
    checkmate::assert_choice(resource_id, datasets_zamg$resource_id)
    checkmate::assert_choice(parameter, metadata_zamg[[resource_id]][["parameters"]][["name"]])
    checkmate::assert_character(station_id)
    checkmate::assert_choice(station_id, metadata_zamg[[resource_id]][["stations"]][["id"]])

    # build url and get result
    url_full <- paste(c(baseurl, version, type, mode, resource_id), collapse = "/")
    query <- paste0(c(paste0("parameters=", parameter),
                      paste0("start=", date_start),
                      paste0("end=", date_end),
                      paste0("station_ids=", station_id)),
                    collapse = "&")

    res <- httr::GET(paste0(url_full, "?", query))
    if(httr::http_error(res)) stop(httr::content(res)$detail)
    json <- httr::content(res)

    # extract only values and no metadata
    datetime <- lubridate::ymd_hms(unlist(json$timestamps))

    y_data <- json$features[[1]]$properties$parameters[[parameter]]$data
    y_data[sapply(y_data, is.null)] <- NA

    dplyr::tibble(datetime = datetime,
                  value = unlist(y_data))


}
