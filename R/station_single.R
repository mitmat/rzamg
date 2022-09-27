#' Download a single time series of one parameter for one station
#'
#' A streamlined combination of \code{\link{station_data}} and
#' \code{\link{query_station}} that only allows one station and one parameter to
#' be downloaded. Only returns the time series without metadata. Also performs
#' some input checks.
#'
#'
#'
#' @param resource_id The resource_id as available in
#'   \code{\link{datasets_zamg}}.
#' @param parameter Parameter (character, length 1), might have different name
#'   depending on resource_id, see also \code{\link{metadata_station}}.
#' @param date_start The start date (ISO8601) to download the time series.
#' @param date_end The end date (ISO8601) to download the time series.
#' @param station_id Station identifier (character, length 1), see also
#'   \code{\link{metadata_station}}.
#'
#' @return A tibble with columns datetime and value.
#'
#' @export
#'
#' @examples
#' station_single(resource_id = "klima-v1-10min",
#'                parameter = "RR",
#'                date_start = "2020-12-24T08:00",
#'                date_end = "2020-12-24T09:00",
#'                station_id = "5904")
#'
station_single <- function(resource_id,
                           parameter,
                           date_start,
                           date_end,
                           station_id){

    checkmate::assert_choice(parameter, metadata_station[[resource_id]][["parameters"]][["name"]])
    checkmate::assert_character(station_id)
    checkmate::assert_choice(station_id, metadata_station[[resource_id]][["stations"]][["id"]])

    # fixed parameters (maybe later generalize and add to function?)
    type <- "station"
    mode <- "historical"

    request <- create_url(type, mode, resource_id) %>%
        query_station(parameter, date_start, date_end, station_id)

    res <- httr::GET(request)
    if(httr::http_error(res)) stop(httr::content(res)$detail)
    json <- httr::content(res)

    # extract only values and no metadata
    datetime <- lubridate::ymd_hms(unlist(json$timestamps))

    y_data <- json$features[[1]]$properties$parameters[[parameter]]$data
    y_data[sapply(y_data, is.null)] <- NA

    dplyr::tibble(datetime = datetime,
                  value = unlist(y_data))


}
