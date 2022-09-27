#' Grid metadata
#'
#' A named list with resource_ids corresponding to grids.
#' Each list item contains again a list of length two.
#'
#'
#' @format
#'
#' The first item (named parameters) holds a tibble of all available parameters
#' for this resource_id.
#'
#' \describe{
#'   \item{name}{Parameter name, used in building the query}
#'   \item{long_name}{Long name}
#'   \item{desc}{Description of the paramater}
#'   \item{unit}{self-explaining}
#' }
#'
#' The second item (named stations) holds a tibble of a grid description
#' for this resource_id.
#'
#' \describe{
#'   \item{title}{Name of the grid}
#'   \item{frequency}{Temporal frequency}
#'   \item{start_time}{Datetime of start}
#'   \item{end_time}{Datetime of end as of package/data generation date
#'       (actual end time might be later)}
#'   \item{spatial_resolution_m}{Grid spacing in metres}
#'   \item{ymin}{Bounding box ymin (min lon)}
#'   \item{xmin}{Bounding box xmin (min lat)}
#'   \item{ymax}{Bounding box ymax (max lon)}
#'   \item{xmax}{Bounding box xmax (max lat)}
#' }
#'
#'
#' @source \url{https://dataset.api.hub.zamg.ac.at/v1/docs/index.html}
"metadata_grid"
