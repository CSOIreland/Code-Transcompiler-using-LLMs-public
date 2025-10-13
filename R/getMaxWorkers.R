#' Gets the max workers, checks for MAX_WORKERS environment var, otherwise uses the value in params file.
#'
getMaxWorkers <- function(){
  if (Sys.getenv("MAX_WORKERS") == "") return(site_params$max_workers)
  return (strtoi(Sys.getenv("MAX_WORKERS")))
}
