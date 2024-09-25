# Packages ----
library(shiny)
library(openai)
library(shinythemes)
library(waiter)
library(shinyAce)
library(future)
library(promises)
library(shinyalert)

# Retrieve API key and instructions ----
www_directory <- paste(getwd(), "/www", sep = "")
# apikey <- as.character(read.delim(paste0(www_directory,"/key.txt"), header = F))

instructions1 <- as.character(readr::read_file(paste0(www_directory,"/instructions1.txt")))
instructions2 <- as.character(readr::read_file(paste0(www_directory,"/instructions2.txt")))

site_params_s <- read_yaml("config.yml")

function(input, output, session) {
  # Render R code box ----
  output$api_response1 <- renderUI({
    aceEditor("api_response1", mode = "r", readOnly = TRUE, fontSize = 13)
  })
  
  # Progress bar ----
  att1 <- Attendant$new("progress-bar1", hide_on_max = TRUE)
  att2 <- Attendant$new("progress-bar2", hide_on_max = TRUE)
  
  # Terms and conditions show only once ----
  observeEvent(input$new_user, {
    req(input$new_user)
    # Pop up Terms and conditions on launch ----
    showModal(
      modalDialog(
        div(id = "terms-content",
            HTML("
                    <h1 style = 'text-align: center;'>Terms and Conditions</h1>
                    <p>By ticking the box below, you are agreeing to follow the Terms and Conditions listed on the Instuctions tab of this app. Please take the time to thoroughly read and understand these terms.</p>
                         ")
        ),
        
        # Disabled submit button when checkbox is not ticked and vice-versa ----
        HTML("
                <div onload = 'disable_Submit()'>
                <input type = 'checkbox' name = 'terms' id = 'terms' onchange = 'activate_Button(this)'/>
                <label for = 'terms'>I have read and agreed to the terms and conditions.</label>
                </div>
                
                <div style = 'text-align: center;'>
                <input type = 'submit' name = 'submit' id = 'submit-terms' disabled data-dismiss = 'modal'/>
                </div>
                     "), 
        
        footer = NULL,
        size = "l"
      )
    )
  })
  
  # Regular Expressions to check for ----
  regexPatternURL <- "\\/(https:\\/\\/www\\.|http:\\/\\/www\\.|https:\\/\\/|http:\\/\\/)?[a-zA-Z]{2,}(\\.[a-zA-Z]{2,})(\\.[a-zA-Z]{2,})?\\/[a-zA-Z0-9]{2,}|((https:\\/\\/www\\.|http:\\/\\/www\\.|https:\\/\\/|http:\\/\\/)?[a-zA-Z]{2,}(\\.[a-zA-Z]{2,})(\\.[a-zA-Z]{2,})?)|(https:\\/\\/www\\.|http:\\/\\/www\\.|https:\\/\\/|http:\\/\\/)?[a-zA-Z0-9]{2,}\\.[a-zA-Z0-9]{2,}\\.[a-zA-Z0-9]{2,}(\\.[a-zA-Z0-9]{2,})?"
  regexPatternFilepath <- "([a-zA-Z]{1,}):\\/\\/([a-zA-Z]{1,})|([a-zA-Z]{1,}):\\/([a-zA-Z]{1,})|([a-zA-Z]{1,}):\\/\\/|([a-zA-Z]{1,}):\\/"
  regexPatternIPaddress <- "(?:[0-9]{1,3}\\.){3}[0-9]{1,3}"
  regexPatternUsernames <- "\\b(username)\\b|\\b(user)\\b|\\b(uid)\\b"
  regexPatternPasswords <- "\\b(password)\\b|\\b(pword)\\b|\\b(pwrd)\\b|\\b(passw)\\b|\\b(pwd)\\b\\/g"
  regexPattern <- paste0(c(regexPatternURL, regexPatternFilepath, 
                           regexPatternIPaddress, regexPatternUsernames, 
                           regexPatternPasswords), collapse="|")
  
  # Check for Regular Expressions in inputted SAS code ----
  regexDetect1 <- reactive({ 
    userInput1 <- input$editing1
    if (grepl(pattern = regexPattern, x = userInput1, ignore.case = T)) {
      return(TRUE)
    } else {
      return(FALSE)
    }
  })
  
  # print(userInput1)
  
  # Check for Regular Expressions in inputted Explanation SAS code ----
  regexDetect2 <- reactive({ 
    userInput2 <- input$editing2
    if (grepl(pattern = regexPattern, x = userInput2, ignore.case = T)) {
      return(TRUE)
    } else {
      return(FALSE)
    }
  })
  
  #print(userInput2)
  
  translationFunct <- function(userInput, instructions) {
    # Loading bar
    att1$set(0)    # Start at 0%
    att1$auto()    # Auto increment
    #print (instructions1)
    # Async process1
    # Send code to run in another session ----
    # print(userInput)
    future({
      # OpenAI API connection ----
      rs <- openai::create_chat_completion(
        # Model used from 10-Nov is the GPT-4 turbo preview. 
        # This model will need to be updated when the preview ends and full release begins
        model = "gpt-4o", 
        
        messages = list(
          list(
            "role" = "system",
            "content" = instructions
          ),
          list(
            "role" = "user",
            "content" = userInput
          )
        ),
        
        temperature = 0,
        
        # max_tokens = 1024, # Controls response length for GPT-4
        max_tokens = 4000, # Increased response length for GPT-4 Turbo (context window is x4 times larger)
        
        openai_api_key = site_params_s$open_ai_key)
      
      
    }) %...>% (
      # Handler when the code is returned ----
      function(rs) {
        # Hide progress bar after 30s
        #print(rs)
        on.exit({
          att1$done()
        })
        
        Sys.sleep(1)
        
        # Response content ----
        if (!is.null(rs)) {
          response <- rs$choices$message.content
          lines <- strsplit(response, "\n")
          lines2 = lines[[1]]
           print("lines 2")
           print(lines2)
          # suppressWarnings(min(data))
          start_line <- min(match(c(paste0("This is not ",site_params_s$from_language," code. "), paste0("This is not ",site_params_s$from_language," code."), paste0("This is not ",site_params_s$from_language," code ")), lines2), 
                            match("```R", lines2), na.rm=TRUE)
           print("start_line")
           print(start_line)
          start_sentence <- lines2[start_line]
          end_line <- which(lines2 == "```")
           print("end_line")
           print(end_line)
          
          
          
          # If is code, just give back the R code equivalent ----
          if(start_sentence=="```R") { 
            code_reconstructed <- paste(lines2[(start_line+1):(end_line-1)], collapse = "\n")
            
          }
          
          # If not code, give back message explaining issue ----
          else{
            code_reconstructed <- paste(lines2, collapse = "\n")
          }
          
          updateAceEditor(session, "api_response1", 
                          value = code_reconstructed,
                          wordWrap = T)
          list(code_reconstructed = code_reconstructed)
        }
        
      }) %...!% (
        # Handler when error is returned ----
        # Typically: Warning: Error in curl::curl_fetch_memory: Failed connect to api.openai.com:443;
        function(rs) {
          showNotification(paste("Error:", rs$message), type = "error")
          
          #print (rs$message)
          #showNotification("hello", type="error")
          # Hide progress bar
          on.exit({
            att1$done()
          })
          
          return(NULL)
        })
  }
  # Once user clicks translate, do the following ----
  observeEvent(input$process1, {
    
    userInput1 <- input$editing1
    # print(userInput)
    
    # Error catching: no input detected ----
    if( nchar(userInput1) > 0 ) {
      
      # Error catching: input SAS code too long ----
      if( nchar(userInput1) > 4000 ) {
        # Hide progress bar on error ----
        on.exit({
          att1$done()
        })
        Sys.sleep(1)
        
        # Error output ----
        updateAceEditor(session, "api_response1", value = paste0("You have entered too much ",site_params_s$from_language," code."))
        
      } else {
        
        # Regular Expression catching ----
        if (regexDetect1() == FALSE) {
          # No regular expression found, send text to API
          translationFunct(userInput = userInput1, instructions = instructions1)
          
        } else { # Create a pop-up warning to inform user that regex has caught some patterns, 
          # Ask user to confirm before sending text to API or do NULL
          shinyalert(
            title = "Information Check",
            text = "Input appears to contain sensitive information\n (URLs/Filepaths/IP addresses/Passwords/etc.)\n
                          Do you wish to proceed with translation?",
            size = "s", closeOnEsc = TRUE, closeOnClickOutside = FALSE,
            html = FALSE, type = "warning",
            showConfirmButton = TRUE, showCancelButton = TRUE,
            confirmButtonText = "Proceed with Translation",
            confirmButtonCol = "#AEDEF4",
            cancelButtonText = "Back",
            timer = 0, animation = TRUE,
            
            callbackR = function(x) {  if(x == FALSE) {return(NULL)} # NA not here
              else{ translationFunct(userInput = userInput1, instructions = instructions1) } 
            }
          )}
        
      } 
    }
    else {
      showNotification(paste("Error: No input detected."), type = "error")
    }
  }) # End observeEvent
  
  explanationFunct <- function(userInput, instructions) {
    # Loading bar
    att2$set(0)    # Start at 0%
    att2$auto()    # Auto increment
    #print (instructions1)
    # Async process1
    # Send code to run in another session ----
    future({
      # OpenAI API connection ----
      rs <- openai::create_chat_completion(
        # Model used from 10-Nov is the GPT-4 turbo preview. 
        # This model will need to be updated when the preview ends and full release begins
        model = "gpt-4o", 
        
        messages = list(
          list(
            "role" = "system",
            "content" = instructions
          ),
          list(
            "role" = "user",
            "content" = userInput
          )
        ),
        
        temperature = 0,
        
        # max_tokens = 1024, # Controls response length for GPT-4
        max_tokens = 4000, # Increased response length for GPT-4 Turbo (context window is x4 times larger)
        
        openai_api_key = site_params_s$open_ai_key)
      
      
    }) %...>% (
      # Handler when the code is returned ----
      function(rs) {
        # Hide progress bar after 30s
        #print(rs)
        on.exit({
          att2$done()
        })
        
        Sys.sleep(1)
        
        # Response content ----
        if (!is.null(rs)) {
          response <- rs$choices$message.content
          lines <- strsplit(response, "\n")
          #print(lines)
          lines2 = lines[[1]]
          #print("lines 2")
          #print(lines2)
          #suppressWarnings(min(data))
          start_line <- lines2[1]
          #print("start_line")
          #print(start_line)
          end_line <- tail(lines2, n=1)
          #print(end_line)
          
          
          
          # If is code, just give back the explanation ----
          if(start_line == "\n") { 
            explanation <- lines2[start_line:(lines2[length(lines2)-1])]
            # Render explanation box ----
            output$outBox <- renderUI({
              HTML(paste(explanation, collapse = "<br>"))
            })
            
          }
          
          # If not code, give back message explaining issue ----
          else{
            explanation <- lines2
            # Render explanation box ----
            output$outBox <- renderUI({
              HTML(paste(explanation, collapse = "<br>"))
            })
          }
          #list(code_reconstructed1 = code_reconstructed1)
        }
        
        
      }) %...!% (
        # Handler when error is returned ----
        # Typically: Warning: Error in curl::curl_fetch_memory: Failed connect to api.openai.com:443;
        function(rs) {
          showNotification(paste("Error:", rs$message), type = "error")
          
          #print (rs$message)
          #showNotification("hello", type="error")
          # Hide progress bar
          on.exit({
            att2$done()
          })
          
          return(NULL)
        })
    
  }
  
  # Once user clicks Explain, do the following ----
  observeEvent(input$process2, {
    
    userInput2 <- input$editing2
    # print(userInput2)
    
    # Error catching: no input detected ----
    if( nchar(userInput2) > 0 ) {
      
      # Error catching: input R code too long ----
      if( nchar(userInput2) > 4000 ) {
        # Hide progress bar on error ----
        on.exit({
          att2$done()
        })
        Sys.sleep(1)
        
        # Error output ----
        textOutput(session, "api_response2", value = paste0("You have entered too much ",site_params_s$from_language," code."))
        
      } else {
        
        # Regular Expression catching ----
        if (regexDetect2() == FALSE) {
          # No regular expression found, send text to API
          explanationFunct(userInput = userInput2, instructions = instructions2)
          
        } else { # Create a pop-up warning to inform user that regex has caught some patterns, 
          # Ask user to confirm before sending text to API or do NULL
          shinyalert(
            title = "Information Check",
            text = "Input appears to contain sensitive information\n (URLs/Filepaths/IP addresses/Passwords/etc.)\n
                          Do you wish to proceed with explanation?",
            size = "s", closeOnEsc = TRUE, closeOnClickOutside = FALSE,
            html = FALSE, type = "warning",
            showConfirmButton = TRUE, showCancelButton = TRUE,
            confirmButtonText = "Proceed with Explanation",
            confirmButtonCol = "#AEDEF4",
            cancelButtonText = "Back",
            timer = 0, animation = TRUE,
            
            callbackR = function(x) {  if(x == FALSE) {return(NULL)} # NA not here
              else{ explanationFunct(userInput = userInput2, instructions = instructions2) } 
            }
          )}
        
      } 
    }
    else {
      showNotification(paste("Error: No input detected."), type = "error")
    }
  }) # End observeEvent
  
} # End server