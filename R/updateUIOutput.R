updateUiOutput <- function(value, output){
  output$response2 <- renderUI({
    HTML(str_replace_all(str_replace_all(value, "\r", ""), "\n", "<br>"))
  })
}