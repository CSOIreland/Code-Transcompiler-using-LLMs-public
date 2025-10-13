
aceOutput <- function(tabIndex){
  return (
    div(id = paste0("response", tabIndex),
        aceEditor(paste0("api_response", tabIndex),
                  height = "798px",
                  mode = "r",
                  fontSize="15",
                  readOnly = TRUE, 
                  wordWrap = TRUE)))
}

standardInput <- function(fromLanguage, tabIndex){
  return(  HTML(
    str_replace_all(
      readFile("html", "TranslatorInputTemplate", "html"),
      c("_input_language_"=fromLanguage, "_tabIndex_"=tabIndex))))
}

aceInput <- function(fromLanguage, tabIndex){
  return( 
    div(id = paste0("editing", tabIndex, "container"), style = "height: 100%",
        HTML(paste0("<label>Input ",fromLanguage," Code:</label>")),
        aceEditor(
          outputId =paste0("editing", tabIndex),
          height = "750px",
          selectionId = "selection",
          fontSize= 15,
          mode = "r",
          placeholder = paste0("Enter ",fromLanguage," Code")
        )
    )
  )
}


uiOutput_ <- function(tabIndex) {
  return (uiOutput(paste0("response", tabIndex)))
}
