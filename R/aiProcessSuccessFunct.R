
aiProcessSuccessFunct <- function(att, 
                                  code_reconstructed = "",
                                  dd_editorId,
                                  dummyData=NULL, 
                                  end_line = 0,
                                  holder = NULL,
                                  lang, 
                                  lines = NULL,
                                  lines2 = NULL,
                                  response, 
                                  session, 
                                  start_line = 0,
                                  start_sentence = "",
                                  translator_editorId# , 
                                  # updateFunction#, 
                                  # ...
                                  ){
  print("aiProcessSuccessFunct called")
  
  # Hide progress bar after 30s
  on.exit({
    att$done()
  })
  Sys.sleep(1)
  
  # Response content ----
  if (!is.null(response)) {
    print("rs is not null")
    # print("\n\n----rs----\n\n")
    # print(rs)
    # print("\n\n----dummyData----\n\n")
    # print(dummyData)
    lines <- strsplit(response, "\n")
    lines2 = lines[[1]]
    print(paste0("To match: \"This is not ",lang," code\""))
    print("------------------lines2-------------------")
    print(lines2)

    start_line <- min(match(c(paste0("This is not ",lang," code"), 
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
    print(paste0("start_line is ", start_line))
    if (start_line == Inf) {start_sentence <- lines2[1]}
    else{start_sentence <- lines2[start_line]}
    
    # print(paste0("start_sentence is ", start_sentence))
    end_line <- which(lines2 == "```")
    if(length(end_line)!=1){end_line <- length(lines2)}
    # print(paste0("end_line is ", end_line))
    
    code_reconstructed <- ""
    # If is code, just give back the R code equivalent ----
    if(start_sentence=="```R") { 
      code_reconstructed <- paste(lines2[(start_line+1):(end_line-1)], 
                                  collapse = "\n")
    }
    # If not code, give back message explaining issue ----
    else{
      code_reconstructed <- paste(lines2, collapse = "\n")
    }
    
    holder$append(code_reconstructed)
    
    print(code_reconstructed)
    print (paste0("aiProcessSuccessFunct got to right before updateFunction. translator_editorId=",translator_editorId))
    updateAceEditor_(editorId = translator_editorId, 
                   session=session,
                   value = holder$returnCurrent())
    
    # This was just to test out the holder functionality ----
    # if (!is.null(holder)){
    #   holder$hello()
    #   print(holder$append(code_reconstructed, "")) # later we'll have some structured data to put here
    #   holder$hello()
    # } else {print("holder is null")}
    
    list(code_reconstructed = code_reconstructed)
  }
  
  # Functionality for the code auto-tester - dummy data display ----
  if(!is.null(dummyData)){ # this *should* be NULL if toCheckBool is FALSE
    print("dummyData is not null")
    dd_response <- dummyData$dd$choices$message.content
    updateAceEditor_(value = dd_response, editorId = dd_editorId, session=session)
  }
}


