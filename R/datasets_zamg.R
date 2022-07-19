#' Available datasets in the ZAMG data hub
#'
#' Information needed to build and check the URLs to access the API.
#'
#' @format A data frame with 63 rows and 4 variables:
#' \describe{
#'   \item{resource_id}{id, name of the resource}
#'   \item{type}{station, grid, or timeseries}
#'   \item{mode}{historical, current, or forecast}
#'   \item{response_formats}{geojson, netcdf, csv}
#' }
#'
#' @source \url{https://dataset.api.hub.zamg.ac.at/v1/docs/index.html}
"datasets_zamg"
