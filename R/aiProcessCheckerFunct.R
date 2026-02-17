# This has a million arguments for the same reason aiProcessCorrectorFunct does.
# (they loop and pass ... so they each have to have all their internal variables as args)
aiProcessCheckerFunct <- function(att,
                                  chatToCheck = "",
                                  checkerInstructions,
                                  code_reconstructed = "",
                                  codeFromUser, 
                                  codeToIterate, 
                                  correctorFunct,
                                  correctorInstructions, 
                                  # dd_editorId,
                                  # dummyData,
                                  end_line = 0,
                                  generatedInstructions = "",
                                  holder,
                                  iter=0, 
                                  iteratedChat = NULL,
                                  iteratedInput = "",
                                  iterationLimit, 
                                  lang,
                                  lines = NULL,
                                  lines2 = NULL,
                                  rs, 
                                  session,
                                  start_line = 0,
                                  start_sentence = "",
                                  successFunct, 
                                  translator_editorId,
                                  # updateFunction,
                                  userInput,
                                  usingIteratedInput = FALSE,
                                  verdict = NULL,
                                  verdictChat = NULL,
                                  ...){
  #call the OpenAI API to verify rs (processed appropriately) is a good translation of userInput
  #if it is, call aiProcessSuccessFunct; if it's not, call a corrector. do this on a loop until you reach a breakpoint
  
  # STEP 1: generate instructions from original SAS code ----
  
  generatedInstructions <- paste(checkerInstructions, userInput, sep="\n")
  
  # STEP 1.5: reconstruct the code from the chat output ----
  if(usingIteratedInput){chatToCheck <- iteratedInput}
  else {chatToCheck <- rs$rs$choices$message.content}
  
  if (is.null(chatToCheck)){stop("chatToCheck is null!")} # nb turn these into proper error messages
  else {print(paste0("\n\nchatToCheck:\n\n",chatToCheck))}
  
  # just copying this whole bit out of aiProcessSuccessFunct - clearly won't do. Need to do better matching
  lines <- strsplit(chatToCheck, "\n")
  lines2 = lines[[1]]
  
  start_line <- min(match("```R", lines2),
                    na.rm=TRUE)
  if (start_line==Inf) { # this is meant to catch if nothing matches the above
    print("calling successFunct because couldn't find code")
    # important that this block exits the function, because otherwise you'll get a failed call to code_reconstructed
    successFunct(att=att,
                 code_reconstructed=NULL,
                 # dd_editorId=dd_editorId,
                 # dummyData=dummyData,
                 end_line=NULL,
                 holder=holder,
                 lang=lang,
                 lines=NULL,
                 lines2=NULL,
                 response=chatToCheck, 
                 session=session, 
                 start_line=NULL,
                 start_sentence=NULL,
                 translator_editorId = translator_editorId# ,     
                 # updateFunction=updateFunction
    ) 
    return()
  }
  start_sentence <- lines2[start_line]
  
  end_line <- which(lines2 == "```")
  if(length(end_line)!=1){end_line <- length(lines2)}
  print(paste0("end_line is ", end_line))
  
  # If is code, just give back the R code equivalent ----
  if(start_sentence=="```R" && iter<iterationLimit) { 
    print(paste0("making code_reconstructed. starting at ", start_line+1, ", ending at ",end_line-1,
                 ", lines2 start_line+1 is ", lines2[(start_line+1)]))
    code_reconstructed <- paste(lines2[(start_line+1):(end_line-1)], collapse = "\n")
    
  }
  else{
    print("calling successFunct without bothering the LLM")
    # important that this block exits the function, because otherwise you'll get a failed call to code_reconstructed
    successFunct(att=att,
                 code_reconstructed=NULL,
                 # dd_editorId=dd_editorId,
                 # dummyData=dummyData,
                 end_line=NULL,
                 holder=holder,
                 lang=lang,
                 lines=NULL,
                 lines2=NULL,
                 response=chatToCheck, 
                 session=session, 
                 start_line=NULL,
                 start_sentence=NULL,
                 translator_editorId = translator_editorId# ,     
                 # updateFunction=updateFunction
                 ) 
    return()
  }
  
  # STEP 2: send both scripts to LLM and ask if the R is a fair translation of the SAS ----
  future({
    # OpenAI API connection
    verdictChat <- runChatCompletion(instructions=generatedInstructions, 
                                     userInput=code_reconstructed)
    print(verdictChat$choices$message.content) # for debug
    if (verdictChat$choices$message.content == "YES") # probably want to do something smart with regex here but w/e
    {verdict <- TRUE}
    else {verdict <- FALSE}
    return (verdict)
  }) %...>% (
    function(verdict){
      if (verdict || iter==iterationLimit){
        print (paste0("aiProcessCheckerFunct calling successFunct. translator_editorId = ", translator_editorId))
        successFunct(att=att,
                     code_reconstructed=NULL,
                     # dd_editorId=dd_editorId,
                     # dummyData=dummyData,
                     end_line=NULL,
                     holder=holder,
                     lang=lang,
                     lines=NULL,
                     lines2=NULL,
                     response=chatToCheck,
                     session=session, 
                     start_line=NULL,
                     start_sentence=NULL,
                     translator_editorId = translator_editorId# ,   
                     # updateFunction=updateFunction
                     ) 
      } else {
        iter = iter + 1
        print(paste0("aiProcessCheckerFunct calling aiProcessCorrectorFunct, iter = ", iter))
        # print(paste0("debug: code_reconstructed length: ", length(code_reconstructed)))
        # this should call a function that attempts to improve the translation, then calls this function on it
        correctorFunct(att=att, 
                       chatToCheck = chatToCheck,
                       checkerInstructions=checkerInstructions, 
                       code_reconstructed=code_reconstructed,
                       codeFromUser=userInput, 
                       codeToIterate=code_reconstructed, 
                       correctorFunct=correctorFunct,
                       correctorInstructions=correctorInstructions,
                       # dd_editorId=dd_editorId,
                       # dummyData=dummyData,
                       end_line=end_line,
                       generatedInstructions=generatedInstructions,
                       holder=holder,
                       iter=iter, 
                       iteratedChat=iteratedChat,
                       iteratedInput=iteratedInput,
                       iterationLimit=iterationLimit, 
                       lang=lang, 
                       lines=lines,
                       lines2=lines2,
                       rs=rs, 
                       session=session,
                       start_line=start_line,
                       start_sentence=start_sentence,
                       successFunct=successFunct, 
                       translator_editorId=translator_editorId, 
                       userInput=userInput, 
                       usingIteratedInput=usingIteratedInput,
                       verdict=verdict,
                       verdictChat=verdictChat,
                       ...)
      }
    }) %...!% (function(){
      showNotification("Error in aiProcessCheckerFunct", type = "error")
      # Hide progress bar
      on.exit({
        att$done()
      })	
    })
}