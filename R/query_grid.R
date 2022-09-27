#' Add query for grid data to the base URL
#'
#' Specify each part of the query and append to the URL, which is created by
#' \code{\link{create_url}}. See \code{\link{metadata_grid}} for help to derive
#' the needed parameters. For how to specify dates, see
#' \url{https://en.wikipedia.org/wiki/ISO_8601}.
#'
#'
#' @param u URL from \code{\link{create_url}}.
#' @param parameters Parameters (character), might have different name depending
#'   on resource_id, see also \code{\link{metadata_grid}}.
#' @param date_start The start date (ISO8601) to download the time series.
#' @param date_end The end date (ISO8601) to download the time series.
#' @param bbox Bounding box, numeric vector of length 4 with special order:
#'   (ymin, xmin, ymax, xmax). See also \code{\link{metadata_grid}} for extent.
#' @param output Output format: netcdf (default) or geojson.
#'
#' @return The request (URL + query) as a character string.
#' @export
#'
#'
#'
#' @examples
#'
#' library(magrittr)
#'
#' create_url(type = "grid", mode = "historical", resource_id = "spartacus-v1-1d-1km") %>%
#'     query_grid(c("RR", "Tn"), "2020-09-01", "2020-09-05", c(47.3, 13.38, 48.2, 14.4))
#'
query_grid <- function(u,
                       parameters,
                       date_start,
                       date_end,
                       bbox,
                       output = "netcdf"){

    query <- paste0(c(paste0("parameters=", paste0(parameters, collapse = ",")),
                      paste0("start=", date_start),
                      paste0("end=", date_end),
                      paste0("bbox=", paste0(bbox, collapse = ",")),
                      paste0("output_format=", output)),
                    collapse = "&")
    paste0(u, "?", query)

}
