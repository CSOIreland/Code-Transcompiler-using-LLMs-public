
aiProcessSuccessFunct <- function(rs, att, lang, updateFunction, ...){
  # Hide progress bar after 30s

  on.exit({
    att$done()
  })
  Sys.sleep(1)
  
  # Response content ----
  if (!is.null(rs)) {
    response <- rs$choices$message.content
    lines <- strsplit(response, "\n")
    lines2 = lines[[1]]

    start_line <- min(match(c(paste0("This is not ",lang," code. "), 
                              paste0("This is not ",lang," code."), 
                              paste0("This is not ",lang," code ")), 
                            lines2), 
                      match("```R", lines2), 
                      match(c("Here is the explanation of the SAS code provided:", 
                              "\"Here is the explanation of the SAS code provided:",
                              "Here is the explanation of the SAS code provided:\r",
                              "\"Here is the explanation of the SAS code provided:\r",
                              "Here is the explanation of the SAS code provided: ",
                              "\"Here is the explanation of the SAS code provided: "),
                            lines2),
                      na.rm=TRUE)
    start_sentence <- lines2[start_line]
    end_line <- which(lines2 == "```")
    
    # If is code, just give back the R code equivalent ----
    if(start_sentence=="```R") { 
      code_reconstructed <- paste(lines2[(start_line+1):(end_line-1)], collapse = "\n")
    }
    # If not code, give back message explaining issue ----
    else{
      code_reconstructed <- paste(lines2, collapse = "\n")
    }
    
    updateFunction(value = code_reconstructed, ...)
                   
  
    list(code_reconstructed = code_reconstructed)
  }
  
}

updateUiOutput <- function(value, output){
  output$response2 <- renderUI({
    HTML(str_replace_all(str_replace_all(value, "\r", ""), "\n", "<br>"))
  })
}
updateAceEditor_ <- function(session, editorId, value){
  updateAceEditor(session=session, editorId=editorId,
                 value = value,
                 wordWrap = T)
}