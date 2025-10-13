page_ <- function(fromLanguage, #fromLanguage,
                  tabIndex,
                  tabName = "", 
                  outputLabel = "",
                  buttonLabel = "",
                  inputElement, 
                  outputElement
                  
){
  # set defaults
  tn <- tabName
  bt <- buttonLabel
  ol <- outputLabel
  if (tabName == "") tn <- paste0(fromLanguage," to ", site_params$to_language," code Assistant")
  if (buttonLabel == "") bt <- paste0("Translate to ", site_params$to_language)
  if (outputLabel == "") ol <- paste0("Output ",site_params$to_language," Code")
  
  
  return(tabPanel(title = tn,
  # Main content ----
  fluidRow(
    column(1),
    column(5,
           # Progress bar ----
           attendantBar(paste0("progress-bar", tabIndex),
                        color = "success",
                        max = 100,
                        striped = TRUE,
                        animated = TRUE,
                        height = "40px",
                        width = "75%"
           ),
           
           # Live syntax highlighting input SAS code box ----
           
           inputElement(fromLanguage, tabIndex),
           
           
           
          
           # Translate button ----
           actionButton(paste0("process", tabIndex), bt)
    ),
    column(5,
           div(id = paste0("output", tabIndex, "container"), style = "height: 100%;",
               style = "width: 95%",
               HTML(paste0("<label>", ol, ":</label>")),
               div(id = paste0("output", tabIndex), 
                   style = "border: 1px solid #CED4DA; height: 800px",
                   outputElement(tabIndex)
               )
           )
    ),
    column(1)
  )
  ))
  
  
}
