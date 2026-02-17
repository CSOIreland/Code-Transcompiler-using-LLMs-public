#' Gets the API Key, checks for OPEN_AI_KEY environment var, otherwise uses the value in params file.
#'
getAPIKey <- function(){
  if (Sys.getenv("OPEN_AI_KEY") == "") return(site_params$open_ai_key)
  return (Sys.getenv("OPEN_AI_KEY"))
}
