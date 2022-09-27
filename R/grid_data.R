#' Download grid data as netcdf
#'
#' Download the output of a request created by \code{\link{query_grid}} into a
#' specified location specified.
#'
#' Note that requests cannot be too large. The limit is 10 million points, which
#' can be reached fast: n_cells_x * n_cells_y * timestamps * parameters. For
#' example, the SPARTACUS grid with 1km horizontal resolution is 183690 grid
#' cells (one timestamp, one param).
#'
#' @param request A request, as created by \code{\link{query_grid}}.
#' @param filename File name to save the netcdf file.
#'
#' @return The filename as character string. Saves in that file along the way.
#'
#' @export
#'
#' @examples
#'
#' library(magrittr)
#'
#' # filename to save
#' file_tmp <- tempfile()
#'
#' create_url(type = "grid", mode = "historical", resource_id = "spartacus-v1-1d-1km") %>%
#'     query_grid(c("RR", "Tn"), "2020-09-01", "2020-09-05", c(47.3, 13.38, 48.2, 14.4)) %>%
#'     grid_data(file_tmp)
#'
grid_data <- function(request, filename){

    res <- httr::GET(request)
    if(httr::http_error(res)) stop(httr::content(res)$detail)

    bin <- httr::content(res, "raw")
    writeBin(bin, filename)

    return(filename)

}
