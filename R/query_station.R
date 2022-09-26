#' Add query for station data to the base URL
#'
#' Specify each part of the query and append to the URL, which is created by
#' \code{\link{create_url}}. See \code{\link{metadata_zamg}} for help to derive
#' the needed parameters. For how to specify dates, see
#' \url{https://en.wikipedia.org/wiki/ISO_8601}.
#'
#'
#' @param u URL from \code{\link{create_url}}.
#' @param parameters Parameters (character), might have different name depending on resource_id,
#'   see also \code{\link{metadata_zamg}}.
#' @param date_start The start date (ISO8601) to download the time series.
#' @param date_end The end date (ISO8601) to download the time series.
#' @param station_ids Station identifiers (character), see also \code{\link{metadata_zamg}}.
#'
#' @return The request (URL + query) as a character string.
#' @export
#'
#'
#'
#' @examples
#'
#' library(magrittr)
#' # The same URL as in the example on
#' # https://dataset.api.hub.zamg.ac.at/v1/docs/quickstart.html
#'
#' create_url(type = "station", mode = "historical", resource_id = "klima-v1-10min") %>%
#'     query_station(parameters = c("TL", "RR", "RRM"),
#'                   date_start = "2020-12-24T08:00",
#'                   date_end = "2020-12-24T09:00",
#'                   station_ids = "5904")
#'
query_station <- function(u,
                          parameters,
                          date_start,
                          date_end,
                          station_ids){

    query <- paste0(c(paste0("parameters=", paste0(parameters, collapse = ",")),
                      paste0("start=", date_start),
                      paste0("end=", date_end),
                      paste0("station_ids=", paste0(station_ids, collapse = ","))),
                    collapse = "&")
    paste0(u, "?", query)

}
