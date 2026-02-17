#' observer function
#' Calls a generic function with runs the basic checks and processes 
#' before calling the openAI related function
#' 
#' @param userInput the input box to read SAS/SPSS from
#' @param instruction the specific instructions to send to openAI
#' @param regexDetect the regextDetect specific to each input to check for i.p. addresses etc
#' @param api_response id of the output box
#' @param language language being sent to the AI
#' @param att the attendant for the API call
#' @param fn the function to call to send text to API
#' @param output the output (same as in server_ function & server.R) - this is only needed for one of the 3 functions defined in fn
#' 
#' @export
iterationObserver <- function(api_response, 
                     att, 
                     correctorInstructions,
                     holder,
                     input,
                     lang,
                     language, 
                     regexDetect, 
                     session,
                     toCheckBool=FALSE,
                     translator_editorId,
                     userInput,
                     userInstructionsInput = NULL,
                     # updateFunction, 
                    # session, 
                     ...){
    print(paste0("iterationObserver called, lang = ",lang))
    # Error catching: no input detected ----
    if( nchar(translator_editorId) == 0 ) {
      showNotification(paste("Error: No translation to update."), type = "error")
      return()
      }
    if( nchar(userInput) == 0 ) {
      showNotification(paste("Error: No input detected."), type = "error")
      return()
    }
  
    # Error catching: input SAS code too long ----
    if( nchar(userInput) > 4000 ) {
      # Hide progress bar on error ----
      on.exit({
        att$done()
      })
      Sys.sleep(1)
      
      # Error output ----
      updateAceEditor_(editorId = api_response,
                     session=session,  
                     value = paste0("You have entered too much ",language," code."))
      
    } else {
      
      # Regular Expression catching ----
      if (regexDetect() == FALSE) {
        
        # No regular expression found, send text to API
        aiIterationFunct(att=att, 
                         correctorInstructions=correctorInstructions,
                         holder=holder,
                         input=input,
                       lang=lang,
                       session=session, 
                       toCheckBool=toCheckBool,
                       translator_editorId=translator_editorId,
                       # updateFunction=updateFunction,
                       userInput = userInput,  
                       userInstructionsInput = userInstructionsInput,
                       #session=session, 
                       ...)
        
      } else { # Create a pop-up warning to inform user that regex has caught some patterns, 
        # Ask user to confirm before sending text to API or do NULL
        
        shinyalert(
          title = "Information Check",
          text = "Input appears to contain sensitive information\n (URLs/Filepaths/IP addresses/Passwords/etc.)\n
                          Do you wish to proceed with translation?",
          size = "s", 
          closeOnEsc = TRUE, 
          closeOnClickOutside = FALSE,
          html = FALSE, type = "warning",
          showConfirmButton = TRUE, 
          showCancelButton = TRUE,
          confirmButtonText = "Proceed with Translation",
          confirmButtonCol = "#AEDEF4",
          cancelButtonText = "Back",
          timer = 0, 
          animation = TRUE,
          
          callbackR = function(x) {  if(x == FALSE) {return(NULL)} # NA not here
            # this is now going to be aiProcessFunct everytime which itself takes a function as an argument
                  #userInput, instructions, att, successFunct
            else{ aiIterationFunct(att=att,
                                   correctorInstructions=correctorInstructions,
                                   holder=holder,
                                   input=input,
                                 lang=lang,
                                 session=session,
                                 toCheckBool=toCheckBool,
                                 translator_editorId=translator_editorId,
                                 userInput = userInput, #  
                                 userInstructionsInput = userInstructionsInput,
                                 ...) } 
            #else{ fn(userInput = userInput, instructions = instructions, att=att, session=session, output=output) } 
          }
        )}
      
    } 
  }