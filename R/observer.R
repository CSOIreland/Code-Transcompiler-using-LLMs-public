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
observer <- function(userInput, regexDetect, api_response, language, att,  ...){
     # Error catching: no input detected ----
    if( nchar(userInput) > 0 ) {
      
      # Error catching: input SAS code too long ----
      if( nchar(userInput) > 4000 ) {
        # Hide progress bar on error ----
        on.exit({
          att$done()
        })
        Sys.sleep(1)
        
        # Error output ----
        updateAceEditor(session, api_response, value = paste0("You have entered too much ",language," code."))
        
      } else {
        
        # Regular Expression catching ----
        if (regexDetect() == FALSE) {
          
          # No regular expression found, send text to API
          aiProcessFunct(userInput = userInput, att=att, ...)
          
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
              else{ aiProcessFunct(userInput = userInput, att=att, ...) } 
              #else{ fn(userInput = userInput, instructions = instructions, att=att, session=session, output=output) } 
            }
          )}
        
      } 
    }
    else {
      showNotification(paste("Error: No input detected."), type = "error")
    }
  }