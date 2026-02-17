#' head function
#' defines the css and js files to be included in the app
#' @export
#'
head <- function(){
  tags$head(
    # favicon:
    # TODO put the favicon code here
    
    # Cookies to remember user on popup Terms ----
    tags$script(src="https://cdn.jsdelivr.net/npm/js-cookie@rc/dist/js.cookie.min.js"),
    # Load cookies script ----
    tags$script(src="includes/cookies.js"),
    
    # Load CSS & JS script ----
    tags$link(rel = "stylesheet", type = "text/css", href = "includes/Transcompiler.css"),
    tags$script(src="includes/Transcompiler.js")
  )
}