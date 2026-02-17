pageDualInput <- function(fromLanguage, #fromLanguage,
                  tabIndex,
                  tabName = "", 
                  outputLabel = "",
                  buttonLabel = "",
                  iterateButtonLabel = "",
                  inputElement, 
                  outputElement
                  
){
  # set defaults
  tn <- tabName
  bt <- buttonLabel
  ib <- iterateButtonLabel
  ol <- outputLabel
  redoLabel <- "Redo"
  undoLabel <- "Undo"
  if (tabName == "") tn <- paste0(fromLanguage," to ", site_params$to_language," code Assistant")
  if (buttonLabel == "") bt <- paste0("Translate to ", site_params$to_language)
  if (iterateButtonLabel == "") ib <- ("Update Translation")
  if (outputLabel == "") ol <- paste0("Output ",site_params$to_language," Code")
  
  return(
    tabPanel(
      title = tn,
      
      # Main content ----
      fluidRow(
        column(1),
        column(5,
            # What determines the order in which these things are placed?
            # The progress bar and translate button stay together at the bottom regardless,
            # but the input and output elements depend on the order they're put in
            
            # Progress bar ----
            attendantBar(
              paste0("progress-bar", tabIndex),
              color = "success",
              max = 100,
              striped = TRUE,
              animated = TRUE,
              height = "40px",
              width = "65%"
            ),
    
            # Translate button ----
            actionButton(paste0("process", tabIndex), bt),
            
            # Live syntax highlighting input SAS code box ----
            # Why does this expand arbitrarily? Why does it swallow the dummy data output box?
            # nb this only happens with standardInput
            # and since I refuse to learn HTML, I will just use aceEditor for everything
            inputElement(fromLanguage, tabIndex),
            aceInputInstructions(fromLanguage, tabIndex),
            fluidRow(
              column(7,
                     actionButton(paste0("iterate", tabIndex), ib),
                     actionButton(paste0("undo", tabIndex), undoLabel),
                     actionButton(paste0("redo", tabIndex), redoLabel)
                     ),
              column(5,
                     sliderInput("iterationSlider",
                                 NULL,
                                 0,
                                 10,
                                 site_params$max_self_corrector_iterations, 
                                 step = 1, 
                                 round = TRUE,
                                 ticks = FALSE,
                                 width = "200px",
                                 post = " self-check cycles"
                                 )
                     )
            )
        ),
        column(5,
               fluidRow(
                 column(9),
                 column(3,actionButton("feedback", "Give feedback"))
                 ),
               div(id = paste0("output", tabIndex, "container"), style = "height: 95%;",
                   style = "width: 95%",
                   HTML(paste0("<label>", ol, ":</label>")),
                   div(id = paste0("output", tabIndex),
                       style = "border: 1px solid #CED4DA; height: 760px",
                       outputElement(tabIndex)
                      )
                  )
        ),
        column(1)
      )
    )
  )
}
