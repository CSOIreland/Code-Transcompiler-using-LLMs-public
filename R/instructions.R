#' defines the instructions tab
#' @export
instructions <- function(){
  return (tabPanel("Instructions",
                   fluidRow(
                     column(2),
                     column(8,
                            div(id = "disclaimer", 
                                readFile("html", "Disclaimer", "html" )
                            )
                     ),
                     column(2)
                   )
  ))
}
