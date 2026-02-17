aceOutput <- function(tabIndex){
  return (
    div(id = paste0("response", tabIndex), style = "height: 100%",
        aceEditor(paste0("api_response", tabIndex),
                  height = "95%",
                  mode = "r",
                  fontSize="15",
                  readOnly = TRUE, 
                  wordWrap = TRUE)))
}

dd_aceOutput <- function(tabIndex){
  return (
    div(id = paste0("dd_response", tabIndex), style = "height: 330px",
        HTML(paste0("<label>Dummy Test Data:</label>")),
        aceEditor(paste0("dd_api_response", tabIndex),
                  height = "90%",
                  mode = "r",
                  fontSize="15",
                  readOnly = TRUE, 
                  wordWrap = TRUE)
        )
    )
}

standardInput <- function(fromLanguage, tabIndex){
  return(  HTML(
    str_replace_all(
      readFile("html", "TranslatorInputTemplate", "html"),
      c("_input_language_"=fromLanguage, "_tabIndex_"=tabIndex))))
}

aceInput <- function(fromLanguage, tabIndex){
  return( 
    div(id = paste0("editing", tabIndex, "container"), style = "height: 830px",
        HTML(paste0("<label>Input ",fromLanguage," Code:</label>")),
        aceEditor(
          outputId =paste0("editing", tabIndex),
          height = "90%",
          selectionId = "selection",
          fontSize= "15",
          mode = "r",
          placeholder = paste0("Enter ",fromLanguage," Code")
        )
      )
  )
}

aceInputInstructions <- function(fromLanguage, tabIndex){
  return( 
    div(id = paste0("editing", tabIndex, "container"), style = "height: 375px",
        HTML(paste0("<label>Add additional instructions:</label>")),
        aceEditor(
          outputId =paste0("editingInstructions", tabIndex),
          height = "90%",
          selectionId = "selection",
          fontSize= "15",
          mode = "plain_text",
          placeholder = paste0("Enter additional instructions")
        )
    )
  )
}

aceInputShort <- function(fromLanguage, tabIndex){
  return( 
    div(id = paste0("editing", tabIndex, "container"), style = "height: 375px",
        HTML(paste0("<label>Input ",fromLanguage," Code:</label>")),
        aceEditor(
          outputId =paste0("editing", tabIndex),
          height = "90%",
          selectionId = "selection",
          fontSize= "15",
          mode = "r",
          placeholder = paste0("Enter ",fromLanguage," Code")
        )
    )
  )
}

uiOutput_ <- function(tabIndex) {
  return (uiOutput(paste0("response", tabIndex)))
}
