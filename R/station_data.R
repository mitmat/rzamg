#' Download and parse station data from URL
#'
#' Transforms the JSON output of a request created by \code{\link{query_station}}
#' into a list that holds almost all the returned information (parameter info,
#' station location, the actual data).
#'
#' @param request A request, as created by \code{\link{query_station}}.
#'
#' @return A list with parameter info, station location, and data (as tibbles).
#'
#' @export
#'
#' @import dplyr
#'
#' @examples
#'
#' library(magrittr)
#' # The same request as in the example on
#' # https://dataset.api.hub.zamg.ac.at/v1/docs/quickstart.html
#'
#' create_url(type = "station", mode = "historical", resource_id = "klima-v1-10min") %>%
#'     query_station(parameters = c("TL", "RR", "RRM"),
#'                   date_start = "2020-12-24T08:00",
#'                   date_end = "2020-12-24T09:00",
#'                   station_ids = "5904") %>%
#'     station_data()
#'
#'
station_data <- function(request){

    res <- httr::GET(request)
    if(httr::http_error(res)) stop(httr::content(res)$detail)

    json <- httr::content(res)

    datetime <- lubridate::ymd_hms(unlist(json$timestamps))

    l_info_stn <- list()
    l_info_par <- list()
    l_data <- list()

    for(i in seq_along(json$features)){

        x <- json$features[[i]]

        l_info_stn[[i]] <- tibble(station_id = x$properties$station,
                                  long = x$geometry$coordinates[[1]],
                                  lat = x$geometry$coordinates[[2]])

        l_info_par[[i]] <- lapply(x$properties$parameters, function(y){
            tibble(parameter_name = y$name,
                   parameter_unit = y$unit)
        }) %>% bind_rows(.id = "parameter_id")

        l_data[[i]] <- lapply(x$properties$parameters, function(y){

            y_data <- y$data
            y_data[sapply(y_data, is.null)] <- NA

            tibble(datetime = datetime,
                   value = unlist(y_data))
        }) %>%
            bind_rows(.id = "parameter_id") %>%
            mutate(station_id = x$properties$station, .before = everything())

    }


    list(
        info_stn = l_info_stn %>% bind_rows(),
        info_par = l_info_par %>% bind_rows() %>% unique,
        data = l_data %>% bind_rows()
    )


}
