library(shiny)
library(openai)
library(shinythemes)
library(waiter)
library(shinyAce)
library(future)
library(promises)
library(shinyalert)

# Retrieve API key and instructions
www_directory <- paste(getwd(), "/www", sep = "")


conf <- read.delim2('app.Config', header=FALSE, sep=':')
for (y in (1:nrow(conf))){
  if (!grepl("#",conf[y,1], fixed=TRUE)){
    if (conf[y,1] == "AI_INSTRUCTIONS"){
      instructions <- conf[y,2]
    } else if (conf[y,1] == "API_KEY"){
      apikey <- conf[y,2]
    } else if (conf[y,1] == "SEARCH_REGEX"){
      regexPattern <- conf[y,2]
    } else if (conf[y,1] == "LANGUAGE_1"){
      lang1 <- conf[y,2]
    } else if (conf[y,1] == "LANGUAGE_2"){
      lang2 <- conf[y,2]
    } else if (conf[y,1] == "LOGO_LOCATION"){
      logo_name <- conf[y,2]
    }
  }
}

#apikey <- as.character(read.delim(paste0(www_directory,"/placeholder_key.txt"), header = F))
#instructions <- as.character(read.delim(paste0(www_directory,"/placeholder_instructions.txt"), header = F))
#regexPattern <- as.character(read.delim(paste0(www_directory,"/regex_pattern.txt"), header = F))

# Open multiple sessions
# Error: Cannot create 128 parallel PSOCK nodes. Each node needs one connection, 
# but there are only 124 connections left out of the maximum 128 available on this 
# R installation
# Default: connections aka workers = 128
plan(multisession, workers = 42)

ui <- fluidPage(
    
    # Cookies to remember user on popup Terms
    HTML('<script src="https://cdn.jsdelivr.net/npm/js-cookie@rc/dist/js.cookie.min.js"></script>'),
  
    # Load cookies script
    tags$script(
        HTML(
            '$(document).on("shiny:connected", function(){
            var newUser = Cookies.get("new_user");
            if(newUser === "false") return;
            Shiny.setInputValue("new_user", true);
            Cookies.set("new_user", false);
            });'
            )
        ),
    
    # Load CSS & JS script
    tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "Transcompiler.css")
        ),
    tags$body(
        tags$script(src="Transcompiler.js")
        ),
    
    # Initialize Progress bar
    theme = bslib::bs_theme(version = 4),
    useAttendant(),
    
    # Branding Image
    headerPanel("SAS to R Transcompiler", title = img(id = "CSO_branding",
                                                      draggable = "false",
                                                      src = "LogoPlacement.png" )
                ),
    
    # Main tabs
    tabsetPanel(
        id="inTabset",
        
        # Tab 1
        tabPanel("SAS to R",
                 fluidRow(
                    column(2),
                    column(8,
                           div(id = "disclaimer", style = "padding: 10px; margin-top: 1px; height: 450px; border: 1px solid #ced4da; border-radius: .25rem;",
                           includeHTML("landingpage_text.html")
                              )
                           ),
                    column(2)
                    )
                 ),
        
        # Tab 2
        tabPanel(title = "SAS to R code Assistant (Pilot)",
                 # Main content
                 fluidRow(
                    column(1),
                    column(5,
                          # Progress bar
                          attendantBar("progress-bar",
                                       color = "success",
                                       max = 100,
                                       striped = TRUE,
                                       animated = TRUE,
                                       height = "40px",
                                       width = "75%"
                                       ),
                          
                          # Live syntax highlighting input SAS code box
                          HTML("<label for='editing'>Input SAS code:</label>"),
                          
                          HTML("
                          <div style = 'height: 750px;'>
                          <textarea placeholder='Enter SAS  Code' 
                          id = 'editing' 
                          spellcheck = 'false' 
                          oninput = 'update(this.value, \"highlighting-content\"); 
                          sync_scroll(this);' 
                          onscroll = 'sync_scroll(this);' 
                          onkeydown = 'check_tab(this, event);'></textarea>
                          <pre id='highlighting' aria-hidden='true'>
                          <code class='language-sas' id='highlighting-content'>
                          </code>
                          </pre>
                               </div>"),
                          
                          #textOutput("sascode"),
                          
                          # Translate button
                          actionButton("process", "Translate to R")
                      ),
                    column(5,
                           div(id = "output", style = "height: 100%;",
                               HTML("<label>Output R code:</label>"),
                               div(id = "output", style = "border: 1px solid #ced4da; height: 800px",
                                   div(id = "response",
                                       aceEditor("api_response",
                                                 height = "798px",
                                                 mode = "r",
                                                 readOnly = TRUE)
                                       ),
                                   )
                               )
                           ),
                    column(1)
                    )
                 )
        )
)

server <- function(input, output, session) {
  #Render R code box
  output$api_response <- renderUI({
    aceEditor("api_response", mode = "r", readOnly = TRUE, fontSize = 13)
  })
  
  #Progress bar
  att <- Attendant$new("progress-bar", hide_on_max = TRUE)
  
  # Terms and conditions show only once
  observeEvent(input$new_user, {
    req(input$new_user)
    # Pop up Terms and conditions on launch
    showModal(
      modalDialog(
        div(id = "terms-content",
            includeHTML("terms_and_conditions.html"),
        ),
        
        # Disabled submit button when checkbox is not ticked and vice-versa
        HTML("
                <div onload = 'disable_Submit()'>
                <input type = 'checkbox' name = 'terms' id = 'terms' onchange = 'activate_Button(this)'/>
                <label for = 'terms'>I have read and agree to the terms and conditions.</label>
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
  
  #check for regular expression in inputted SAS code
  regexDetect <- reactive({ 
    userInput <- input$editing
    if (grepl(pattern = regexPattern, x = userInput, ignore.case = T)) {
      return(TRUE)
    } else {
      return(FALSE)
    }
  })
  
  translationFunct <- function(userInput, instructions) {
    #loading bar
    att$set(0)    # start at 0%
    att$auto()    # auto increment
    
    # Async process
    # Send code to run in another session
    future({
      #OpenAI API connection
      rs <- openai::create_chat_completion(
        # Model used from 10-Nov is the GPT-4 turbo preview. 
        # This model will need to be updated when the preview ends and full release begins
        model = "gpt-4-1106-preview", 
        
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
        
        #max_tokens = 1024, # Controls response length for GPT-4
        max_tokens = 4000, # Increased response length for GPT-4 Turbo (context window is x4 times larger)
        
        openai_api_key = apikey)
      
    }) %...>% (
      # Handler when the code is returned
      function(rs) {
        # Hide progress bar after 30s
        on.exit({
          att$done()
        })
        
        Sys.sleep(1)
        
        # Response content
        if (!is.null(rs)) {
          response <- rs$choices$message.content
          lines <- strsplit(response, "\n")
          lines2 = lines[[1]]
          start_line <- min(match(c("This is not SAS code. ", "This is not SAS code.", "This is not SAS code "), lines2), 
                            match("```R", lines2), na.rm=TRUE)
          start_sentence <- lines2[start_line]
          end_line <- which(lines2 == "```")
          print(lines2)
          print(start_line)
          print(end_line)
          
          
          # if is code, just give back the R code equivalent 
          if(start_sentence=="```R") { 
            code_reconstructed <- paste(lines2[(start_line+1):(end_line-1)], collapse = "\n")
            
          }
          
          # if not code, give back message explaining issue
          else{
            code_reconstructed <- paste(lines2, collapse = "\n")
          }
          
          updateAceEditor(session, "api_response", 
                          value = code_reconstructed,
                          wordWrap = T)
          list(code_reconstructed = code_reconstructed)
        }
        
      }) %...!% (
        # Handler when error is returned
        # Typically: Warning: Error in curl::curl_fetch_memory: Failed connect to api.openai.com:443;
        function(rs) {
          showNotification(paste("Error:", rs$message), type = "error")
          # Hide progress bar
          on.exit({
            att$done()
          })
          
          return(NULL)
        })
  }
  #once user clicks translate, do the following
  observeEvent(input$process, {
    
    userInput <- input$editing
    #print(userInput)
    
    # Error catching: no input detected
    if( nchar(userInput) > 0 ) {
      
      # Error catching: input SAS code too long
      if( nchar(userInput) > 6000 ) {
        # Hide progress bar on error
        on.exit({
          att$done()
        })
        Sys.sleep(1)
        
        # Error output
        updateAceEditor(session, "api_response", value = "You have entered too much SAS code.")
        
      } else {
        
        #regular expression catching.
        if (regexDetect() == FALSE) {
          # No regular expression found, send text to API
          translationFunct(userInput = userInput, instructions = instructions)
          
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
            callbackR = function(x) { if(x == FALSE) {return(NULL)}
                          else{ translationFunct(userInput = userInput, instructions = instructions) } 
              }
          )}
        
        } 
      }
    else {
        showNotification(paste("Error: No input detected."), type = "error")
      }
  }) #end observeEvent
  
} #end server

shinyApp(ui = ui, server = server)