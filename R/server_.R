#' Core server function
#' 
#' Defines the core server function called from server.R
#'
#' @param input app inputs
#' @param output app outputs
#' @param session app session
#' @export
server_ <- function(input, output, session) {
 
  # read instructions from instructions txt files
  instructions1 <- readFile("text", "instructions1", "instructions")
  instructions2 <- readFile("text", "instructions2", "instructions")
  instructions3 <- readFile("text", "instructions3", "instructions")
  
  # render R Output boxes
  responses(output)
  
  # create progress bars (I wonder if its possible to have 1 progress bar for the whole thing)
  att1 <- Attendant$new("progress-bar1", hide_on_max = TRUE)
  att2 <- Attendant$new("progress-bar2", hide_on_max = TRUE)
  att3 <- Attendant$new("progress-bar3", hide_on_max = TRUE)
  
  # initiate observe event for first time users to be presented with T&Cs
  termsandconditions(input)
  
  # generate regex pattern from params
  regexPattern <- paste0(site_params$regex, collapse="|")
  
  # define regex reactive methods for each input (again can we have 1 input perhaps?)
  regexDetect1 <- reactive(return(grepl(pattern = regexPattern, x = input$editing1, ignore.case = T)))
  regexDetect2 <- reactive(return(grepl(pattern = regexPattern, x = input$editing2, ignore.case = T)))
  regexDetect3 <- reactive(return(grepl(pattern = regexPattern, x = input$editing3, ignore.case = T)))
  
  
  # initiate observe events for each button
  # SAS to R translation
  observeEvent(input$process1, 
               observer( 
                 userInput=input$editing1, 
                 regexDetect=regexDetect1, 
                 api_response="api_response1", 
                 language = site_params$from_language, 
                 att=att1, 
                 instructions=instructions1, #... 
                 successFunct=aiProcessSuccessFunct, 
                 session = session, 
                 lang = site_params$from_language, 
                 editorId = "api_response1",
                 updateFunction = updateAceEditor_
              )
  )
  # SAS code explainer
  observeEvent(input$process2,
               observer(userInput=input$editing2, 
                        regexDetect=regexDetect2, 
                        api_response="response2",
                        language = site_params$from_language, 
                        att=att2,
                        instructions=instructions2, #...
                        successFunct=aiProcessSuccessFunct, 
                        lang = site_params$from_language, 
                        output = output,
                        updateFunction = updateUiOutput
                      )
               )

  # SPSS to R translator
  observeEvent(input$process3, observer(
                    userInput=input$editing3, instructions=instructions3, 
                    regexDetect=regexDetect1, api_response="api_response3", 
                    language = site_params$from_language, att=att3, 
                    successFunct=aiProcessSuccessFunct, session = session, 
                    lang = site_params$from_language_2, editorId="api_response3",
                    updateFunction = updateAceEditor_
                ))
  
  
} # End server