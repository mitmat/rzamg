#' Create the URL for the ZAMG data hub API
#'
#' Build the URL to access the API by specifying each part. The needed
#' information is available as internal dataset \code{\link{datasets_zamg}} with
#' column names the same as function parameters.
#'
#' @param type Data type, as available in \code{\link{datasets_zamg}}.
#' @param mode Data mode, as available in \code{\link{datasets_zamg}}.
#' @param resource_id The resource_id, as available in \code{\link{datasets_zamg}} .
#'
#' @return The URL as a character string.
#'
#' @export
#'
#' @examples
#' # The first part of the URL as in the example on
#' # https://dataset.api.hub.zamg.ac.at/v1/docs/quickstart.html
#'
#' create_url(type = "station",
#'            mode = "historical",
#'            resource_id = "klima-v1-10min")
#'
create_url <- function(type, mode, resource_id){

    # fixed parameters
    baseurl <- "https://dataset.api.hub.zamg.ac.at"
    version  <- "v1" # only v1 as of 2022-07-13

    checkmate::assert_choice(type, datasets_zamg$type)
    checkmate::assert_choice(mode, datasets_zamg$mode)
    checkmate::assert_choice(resource_id, datasets_zamg$resource_id)

    # combined check
    if(!any(datasets_zamg$type == type &
            datasets_zamg$mode == mode &
            datasets_zamg$resource_id == resource_id)){
        stop("Combination of ", type, ", ", mode, ", and ", resource_id,
             " not available.\n", "Check with datasets_zamg table.")
    }

    paste(c(baseurl, version, type, mode, resource_id), collapse = "/")

}
