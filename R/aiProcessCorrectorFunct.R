# This has a million arguments for the same reason aiProcessCheckerFunct does.
aiProcessCorrectorFunct <- function(att,
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
  print("debug: aiProcessCorrectorFunct called")
  
  # generate instructions from codeFromUser ----
  generatedInstructions <- paste(correctorInstructions, codeFromUser, sep="\n")
  # print("debug: generatedInstructions generated")
  # print(paste0("debug: generatedInstructions length ", length(generatedInstructions)))
  # print(paste0("debug: codeToIterate length ", length(codeToIterate)))
  
  future({
    # OpenAI API connection
    iteratedChat <- runChatCompletion(instructions=generatedInstructions, 
                                      userInput=codeToIterate)
    iteratedContent <- iteratedChat$choices$message.content
    # nb turn these into proper error messages
    if (is.null(iteratedContent)){stop("iteratedChat is null!")} 
    
    print("debug: got iteratedChat")
    
    return(iteratedContent)
  }) %...>% (function(iteratedContent){
    print("debug: inputIterated successfully returned")
    aiProcessCheckerFunct(att=att,
                          chatToCheck=chatToCheck,
                          checkerInstructions=checkerInstructions,
                          code_reconstructed=code_reconstructed,
                          codeFromUser=codeFromUser,
                          codeToIterate=codeToIterate,
                          correctorFunct=correctorFunct,
                          correctorInstructions=correctorInstructions,
                          # dd_editorId=dd_editorId,
                          # dummyData=dummyData,
                          end_line=end_line,
                          generatedInstructions=generatedInstructions,
                          holder=holder,
                          iter=iter, 
                          iteratedChat=iteratedChat,
                          iteratedInput=iteratedContent,
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
                          usingIteratedInput=TRUE, 
                          verdict=verdict,
                          verdictChat=verdictChat,
                          ...)
  }) %...!% (function(iteratedContent){
    print(iteratedContent$message)
    errorFunct(rs=iteratedContent, att=att)})
}