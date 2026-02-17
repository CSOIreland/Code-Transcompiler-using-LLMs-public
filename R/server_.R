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
  instructions4 <- readFile("text", "instructions4", "instructions") #this is for dummy data generation
  checkerInstructions1 <- readFile("text", "checkerInstructions1", "instructions")
  checkerInstructions3 <- readFile("text", "checkerInstructions3", "instructions")
  correctorInstructions1 <- readFile("text", "correctorInstructions1", "instructions")
  correctorInstructions3 <- readFile("text", "correctorInstructions3", "instructions")
  manualIteratorInstructions <- readFile("text", "manualIteratorInstructions", "instructions")
  
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
  
  # create holder for update history etc ----
  holderForSasTranslations <- holderMaker(currentIndex = 0L, editHistory = list(), nextIndex = 1L)
  explanationHolder <- holderMaker(currentIndex = 0L, editHistory = list(), nextIndex = 1L)
  spssHolder <- holderMaker(currentIndex = 0L, editHistory = list(), nextIndex = 1L)
  
  # initiate observe events for each button
  # SAS to R translation
  observeEvent(input$process1, 
               observer( 
                 api_response="api_response1", 
                 att=att1, 
                 checkerFunct=aiProcessCheckerFunct,
                 checkerInstructions = checkerInstructions1,
                 correctorFunct = aiProcessCorrectorFunct,
                 correctorInstructions = correctorInstructions1,
                 # dd_editorId = "dd_api_response1", # put id of dummy data display textbox here
                 # dummyDataInstructions = instructions4, # for dummy data generation
                 holder = holderForSasTranslations,
                 instructions=instructions1, #... 
                 iterationLimit = input$iterationSlider,
                 lang = site_params$from_language, 
                 language = site_params$from_language, 
                 regexDetect=regexDetect1, 
                 session = session, 
                 successFunct=aiProcessSuccessFunct, 
                 toCheckBool = TRUE,
                 translator_editorId = "api_response1",
                 # updateFunction = updateAceEditor_,
                 userInput=input$editing1,
                 userInstructionsInput=input$editingInstructions1
              )
  )
  observeEvent(input$iterate1,
               iterationObserver(
                 api_response="api_response1", 
                 att=att1, 
                 checkerFunct=aiProcessCheckerFunct,
                 checkerInstructions = checkerInstructions1,
                 correctorFunct = aiProcessCorrectorFunct,
                 correctorInstructions = manualIteratorInstructions,
                 # dd_editorId = "dd_api_response1", # put id of dummy data display textbox here
                 # dummyDataInstructions = instructions4, # for dummy data generation
                 holder = holderForSasTranslations,
                 input=input,
                 instructions=instructions1, #... 
                 iterationLimit = input$iterationSlider,
                 lang = site_params$from_language, 
                 language = site_params$from_language, 
                 regexDetect=regexDetect1, 
                 session = session, 
                 successFunct=aiProcessSuccessFunct, 
                 toCheckBool = FALSE,
                 translator_editorId = "api_response1",
                 # updateFunction = updateAceEditor_,
                 userInput=input$editing1,
                 userInstructionsInput=input$editingInstructions1
               )
  )
  # SAS to R undo/redo functionality
  observeEvent(input$redo1,
               updateAceEditor_(editorId = "api_response1", 
                                session = session,
                                value = holderForSasTranslations$stepForward())
               )
  observeEvent(input$undo1,
               updateAceEditor_(editorId = "api_response1", 
                                session = session,
                                value = holderForSasTranslations$stepBack())
               )
  # SAS code explainer
  observeEvent(input$process2,
               observer(api_response="response2",
                        att=att2,
                        # dd_editorId = "dd_api_response1", # put id of dummy data display textbox here
                        holder = explanationHolder,
                        instructions=instructions2, #...
                        lang = site_params$from_language, 
                        language = site_params$from_language, 
                        output = output,
                        regexDetect=regexDetect2, 
                        session = session, 
                        successFunct=aiProcessSuccessFunct, 
                        translator_editorId="response2",
                        updateFunction = updateUiOutput, 
                        userInput=input$editing2
                      )
               )

  # SPSS to R translator
  observeEvent(input$process3, observer(
                    api_response="api_response3",
                    att=att3, 
                    checkerFunct=aiProcessCheckerFunct,
                    checkerInstructions = checkerInstructions3,
                    correctorFunct = aiProcessCorrectorFunct,
                    correctorInstructions = correctorInstructions3,
                    # dd_editorId = "dd_api_response1", # put id of dummy data display textbox here
                    holder = spssHolder,
                    input=input,
                    instructions=instructions3, 
                    iterationLimit = input$iterationSlider,
                    lang = site_params$from_language_2, 
                    language = site_params$from_language,
                    regexDetect=regexDetect1,  
                    session = session,  
                    successFunct=aiProcessSuccessFunct,
                    toCheckBool = TRUE,
                    translator_editorId="api_response3",
                    updateFunction = updateAceEditor_,
                    userInput=input$editing3,
                    userInstructionsInput=input$editingInstructions3
                ))
  observeEvent(input$iterate3,
               iterationObserver(
                 api_response="api_response3", 
                 att=att3, 
                 checkerFunct=aiProcessCheckerFunct,
                 checkerInstructions = checkerInstructions3,
                 correctorFunct = aiProcessCorrectorFunct,
                 correctorInstructions = manualIteratorInstructions,
                 # dd_editorId = "dd_api_response1", # put id of dummy data display textbox here
                 # dummyDataInstructions = instructions4, # for dummy data generation
                 holder = spssHolder,
                 input=input,
                 instructions=instructions3, #... 
                 iterationLimit = input$iterationSlider,
                 lang = site_params$from_language, 
                 language = site_params$from_language, 
                 regexDetect=regexDetect3, 
                 session = session, 
                 successFunct=aiProcessSuccessFunct, 
                 toCheckBool = FALSE,
                 translator_editorId = "api_response3",
                 # updateFunction = updateAceEditor_,
                 userInput=input$editing3,
                 userInstructionsInput=input$editingInstructions3
               )
  )
  # SPSS to R undo/redo functionality
  observeEvent(input$redo3,
               updateAceEditor_(editorId = "api_response3", 
                                session = session,
                                value = spssHolder$stepForward())
  )
  observeEvent(input$undo3,
               updateAceEditor_(editorId = "api_response3", 
                                session = session,
                                value = spssHolder$stepBack())
  )
  
  #Feedback button
  observeEvent(input$feedback,
               # this should serve an appropriate popup
               feedbackForm()
  )
  observeEvent(input$submitFeedback,
               sendFeedback(input=input)
  )
} # End server