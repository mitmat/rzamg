#' Create the URL for the ZAMG data hub API
#'
#' Build the URL to access the API by specifying each part of the query.
#' The meta data is available as internal datasets \code{\link{datasets_zamg}}
#' and \code{\link{metadata_zamg}}, the contents of which might help to
#' derive the needed parameters.
#' For how to specify dates, see \url{https://en.wikipedia.org/wiki/ISO_8601}.
#'
#' @param resource_id The resource_id as available in \code{\link{datasets_zamg}}.
#' @param parameters Parameters (character), might have different name depending on resource_id,
#'   see also \code{\link{metadata_zamg}}.
#' @param date_start The start date (ISO8601) to download the time series.
#' @param date_end The end date (ISO8601) to download the time series.
#' @param station_ids Station identifiers (character), see also \code{\link{metadata_zamg}}.
#' @param type Data type, currently, pkg is only tested with "station" (default).
#' @param mode Data mode, currently, pkg is only tested with "historical" (default).
#'
#' @return The URL as a character string.
#'
#' @export
#'
#' @examples
#' # The same URL as in the example on
#' # https://dataset.api.hub.zamg.ac.at/v1/docs/quickstart.html
#'
#' create_url(resource_id = "klima-v1-10min",
#'            parameters = c("TL", "RR", "RRM"),
#'            date_start = "2020-12-24T08:00",
#'            date_end = "2020-12-24T09:00",
#'            station_ids = "5904")
#'
create_url <- function(resource_id,
                       parameters,
                       date_start,
                       date_end,
                       station_ids,
                       type = "station",
                       mode = "historical"){
    # fixed parameters
    baseurl <- "https://dataset.api.hub.zamg.ac.at"
    version  <- "v1" # only v1 as of 2022-07-13

    checkmate::assert_choice(type, c("station", "grid", "timeseries"))
    checkmate::assert_choice(mode, c("historical", "current", "forecast"))
    checkmate::assert_choice(resource_id, datasets_zamg$resource_id)

    url_full <- paste(c(baseurl, version, type, mode, resource_id), collapse = "/")
    query <- paste0(c(paste0("parameters=", paste0(parameters, collapse = ",")),
                      paste0("start=", date_start),
                      paste0("end=", date_end),
                      paste0("station_ids=", paste0(station_ids, collapse = ","))),
                    collapse = "&")
    paste0(url_full, "?", query)
}
