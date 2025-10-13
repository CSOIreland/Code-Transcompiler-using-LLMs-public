#' renders output boxes for API responses from the openAI.
#' weirdly only for SAS to R and SPSS to R
#' 
#' questions: 
#'  - can this be generalised since the two sets of 3 lines are the same
#'  - why is this only used for 2 of the three API calls?
#'   
#' @param output the global output variable from server.R
#' @export
responses <- function(output){
  # Render R code box ----
  
  output$api_response1 <- renderUI({
    aceEditor("api_response1", mode = "r", readOnly = TRUE, fontSize = 13)
  })
  
  output$api_response2 <- renderUI({
    aceEditor("api_response2", mode = "r", readOnly = TRUE, fontSize = 13)
  })
   
  output$api_response3 <- renderUI({
    aceEditor("api_response3", mode = "r", readOnly = TRUE, fontSize = 13)
  })

}