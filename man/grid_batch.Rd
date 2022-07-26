% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/grid_batch.R
\name{grid_batch}
\alias{grid_batch}
\title{Download multiple timestamps of a grid at once}
\usage{
grid_batch(
  resource_id,
  parameters,
  date_start,
  date_end,
  path_dir_save,
  bbox,
  show_progress = TRUE
)
}
\arguments{
\item{resource_id}{The resource_id as available in
\code{\link{datasets_zamg}}.}

\item{parameters}{Parameters (character), might have different name depending
on resource_id, see also \code{\link{metadata_grid}}.}

\item{date_start}{The start date (Date-class).}

\item{date_end}{The end date (Date-class).}

\item{path_dir_save}{Directory folder to save files.}

\item{bbox}{Bounding box, numeric vector of length 4 with special order:
(ymin, xmin, ymax, xmax). If missing, the whole extent will be extracted
from \code{\link{metadata_grid}}.}

\item{show_progress}{Logical, if TRUE (default), shows progress bar.}
}
\value{
The directory path as character string. Saves files along the way.
}
\description{
Wrapper around \code{\link{grid_data}}, with some extra functionality. Will
download all parameters and all timestamps, and save them in the given
directory with one file per timestamp, which holds all parameters.
}
\details{
Start and end dates must be specified as Date class (currently does not work
for hourly grids). For monthly grids, the start_date should have day=01, as
this is also the timestamp in the netcdf.
}
\examples{

\dontrun{

path_dir_save <- tempdir() # temporary directory for examples

grid_batch(resource_id = "spartacus-v1-1m-1km",
           parameters = c("Tm", "RR"),
           date_start = lubridate::ymd("2000-01-01"),
           date_end = lubridate::ymd("2012-01-31"),
           path_dir_save = path_dir_save)

}

}
