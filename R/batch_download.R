#' Download multiple time series and parameters at once
#'
#' Wrapper around \code{\link{single_series}}, with some extra functionality.
#' Will download all parameters and all station specified, and save them in
#' the given directory. Start and end date can be omitted, in which case the
#' whole time series up to the current time will be downloaded.
#'
#' Creates a folder for each parameter within path_dir_save, and saves the
#' downloaded tables as rds-files that have the station id as filename. If
#' the file already exists, it will be skipped (so it can be downloaded in
#' multiple sessions).
#'
#' If save_extra is TRUE, then the downloaded single series will be combined
#' into one tibble storing all stations and parameters. Additionally, tibbles
#' will be save with information on parameters and stations, which are subsets
#' of \code{\link{metadata_zamg}}. In summary, the resulting files allow fast
#' working with the data.
#'
#' @param resource_id The resource_id as available in \code{\link{datasets_zamg}}.
#' @param parameters Parameters (character), might have different name depending on resource_id,
#'   see also \code{\link{metadata_zamg}}.
#' @param station_ids Station identifiers (character), see also \code{\link{metadata_zamg}}.
#' @param path_dir_save Directory folder to save files.
#' @param date_start The start date (ISO8601) to download the time series. If missing,
#'   starting date will be extracted from internal metadata.
#' @param date_end The end date (ISO8601) to download the time series. Default: current
#'   system time.
#' @param save_extra Logical, if TRUE, saves combined data with auxiliary info.
#' @param show_progress Logical, if TRUE, shows progress bar.
#' @param type Data type, currently, pkg is only tested with "station" (default).
#' @param mode Data mode, currently, pkg is only tested with "historical" (default).
#'
#' @return The directory path as character string. Saves files along the way.
#'
#' @export
#'
#' @import fs
#' @import dplyr
#' @import progress
#'
#' @examples
#' \dontrun{
#'
#' # which snow parameters are there for monthly data?
#' metadata_zamg$`klima-v1-1m`$parameters %>%
#'     dplyr::filter(grepl("schnee", long_name, ignore.case = TRUE))
#'
#' # take monthly cumulative snowfall and maximum snow height
#' params <- c("nsch", "schmax")
#'
#' # subset stations above 2000m and with data starting before 1920
#' stn_ids <- metadata_zamg$`klima-v1-1m`$stations %>%
#'     dplyr::filter(altitude > 2000, valid_from < "1920-01-01") %>%
#'     dplyr::pull(id)
#'
#' # path to save
#' path_dir_save <- tempdir() # temporary directory for examples
#'
#' # download whole time series
#' batch_download(resource_id = "klima-v1-1m",
#'                parameters = params,
#'                station_ids = stn_ids,
#'                path_dir_save = path_dir_save)
#' }
#'
batch_download <- function(resource_id,
                           parameters,
                           station_ids,
                           path_dir_save,
                           date_start,
                           date_end = lubridate::format_ISO8601(Sys.time()),
                           save_extra = FALSE,
                           show_progress = TRUE,
                           type = "station",
                           mode = "historical"){

    checkmate::assert_choice(resource_id, datasets_zamg$resource_id)
    checkmate::assert_subset(parameters, metadata_zamg[[resource_id]][["parameters"]][["name"]])
    checkmate::assert_directory_exists(path_dir_save)

    if(missing(station_ids)) station_ids <- metadata_zamg[[resource_id]][["stations"]][["id"]]

    if(save_extra) l_data <- list()

    pb <- progress_bar$new(total = length(parameters) * length(station_ids),
                           format = "[:bar] :percent eta: :eta (parameter: :par, station: :stn)")

    for(i_par in parameters){

        dir_create(path(path_dir_save, i_par))

        for(i_stn in station_ids){

            fn_stn <- path(path_dir_save, i_par, i_stn, ext = "rds")

            if(!file_exists(fn_stn)){

                if(missing(date_start)){

                    metadata_zamg[[resource_id]][["stations"]] %>%
                        filter(id == i_stn) %>%
                        pull(valid_from) %>%
                        lubridate::format_ISO8601() -> date_start

                }

                tbl_stn <- single_series(resource_id = resource_id,
                                         parameter = i_par,
                                         date_start = date_start,
                                         date_end = date_end,
                                         station_id = i_stn)

                saveRDS(tbl_stn, fn_stn)
            } else {
                if(save_extra) tbl_stn <- readRDS(fn_stn)
            }

            if(save_extra) {
                l_data[[paste0(i_par, "_", i_stn)]] <- tbl_stn %>%
                    mutate(station_id = i_stn, parameter = i_par, .before = everything())
            }


            pb$tick(tokens = list(par = i_par, stn = i_stn))

        }



    }

    if(save_extra){

        metadata_zamg[[resource_id]][["parameters"]] %>%
            filter(name %in% parameters) %>%
            saveRDS(path(path_dir_save, "info-parameters", ext = "rds"))

        metadata_zamg[[resource_id]][["stations"]] %>%
            filter(id %in% station_ids) %>%
            saveRDS(path(path_dir_save, "info-stations", ext = "rds"))

        l_data %>%
            bind_rows() %>%
            tidyr::pivot_wider(names_from = parameter, values_from = value) %>%
            saveRDS(path(path_dir_save, "all-data", ext = "rds"))


    }

    return(path_dir_save)

}





