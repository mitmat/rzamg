#' Download multiple timestamps of a grid at once
#'
#' Wrapper around \code{\link{grid_data}}, with some extra functionality. Will
#' download all parameters and all timestamps, and save them in the given
#' directory with one file per timestamp, which holds all parameters.
#'
#' Start and end dates must be specified as Date class (currently does not work
#' for hourly grids). For monthly grids, the start_date should have day=01, as
#' this is also the timestamp in the netcdf.
#'
#'
#' @param resource_id The resource_id as available in
#'   \code{\link{datasets_zamg}}.
#' @param parameters Parameters (character), might have different name depending
#'   on resource_id, see also \code{\link{metadata_grid}}.
#' @param date_start The start date (Date-class).
#' @param date_end The end date (Date-class).
#' @param path_dir_save Directory folder to save files.
#' @param bbox Bounding box, numeric vector of length 4 with special order:
#'   (ymin, xmin, ymax, xmax). If missing, the whole extent will be extracted
#'   from \code{\link{metadata_grid}}.
#' @param show_progress Logical, if TRUE (default), shows progress bar.
#'
#' @return The directory path as character string. Saves files along the way.
#'
#' @export
#'
#' @import fs
#' @import magrittr
#' @import dplyr
#' @import progress
#'
#' @examples
#'
#' \dontrun{
#'
#' path_dir_save <- tempdir() # temporary directory for examples
#'
#' grid_batch(resource_id = "spartacus-v1-1m-1km",
#'            parameters = c("Tm", "RR"),
#'            date_start = lubridate::ymd("2000-01-01"),
#'            date_end = lubridate::ymd("2012-01-31"),
#'            path_dir_save = path_dir_save)
#'
#' }
#'
grid_batch <- function(resource_id,
                       parameters,
                       date_start,
                       date_end,
                       path_dir_save,
                       bbox,
                       show_progress = TRUE){

    checkmate::assert_choice(resource_id, datasets_zamg$resource_id)
    checkmate::assert_subset(parameters, metadata_grid[[resource_id]][["parameters"]][["name"]])
    checkmate::assert_directory_exists(path_dir_save)
    checkmate::assert_date(date_start, lower = metadata_grid[[resource_id]][["grid"]][["start_time"]])
    checkmate::assert_date(date_end)

    if(missing(bbox)) {
        bbox <- unlist(
            metadata_grid[[resource_id]][["grid"]][c("ymin", "xmin", "ymax", "xmax")]
        )
    }

    if(date_end > metadata_grid[[resource_id]][["grid"]][["end_time"]]){
        warning("date_end outside of what is known from metadata_grid (possibly outdated); ",
                "empty netcdf files might be saved.")
    }

    # create date loop vector
    by_date <- switch(strsplit(resource_id, "-")[[1]][3],
           "1h" = stop("1h not implemented"),
           "1d" = "1 day",
           "1m" = "1 month")
    all_dates <- seq(date_start, date_end, by = by_date)

    pb <- progress_bar$new(total = length(all_dates),
                           format = "[:bar] :percent eta: :eta (date: :date)")

    for(i in seq_along(all_dates)){

        fn_date <- path(path_dir_save, all_dates[i], ext = "nc")

        if(!file_exists(fn_date)){


            create_url("grid", "historical", resource_id) %>%
                query_grid(parameters, all_dates[i], all_dates[i], bbox) %>%
                grid_data(fn_date)


            pb$tick(tokens = list(date = all_dates[i]))

        }

    }

    return(path_dir_save)

}





