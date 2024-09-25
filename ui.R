library(shiny)
library(shinythemes)
library(waiter)
library(shinyAce)
library(future)
library(promises)
library(shinyalert)
library(yaml)
library(stringr)

# Retrieve API key and instructions ----
www_directory_ui <- paste(getwd(), "/www", sep = "")
# Open multiple sessions ----
# Error: Cannot create 128 parallel PSOCK nodes. Each node needs one connection, 
# But there are only 124 connections left out of the maximum 128 available on this 
# R installation
# Default: connections aka workers = 128
plan(multisession, workers = 4)

site_params <- read_yaml("config.yml")

instructions <- function(){
  return (tabPanel("Instructions",
                   fluidRow(
                     column(2),
                     column(8,
                            div(id = "disclaimer", style = "padding: 10px; margin-top: 1px; height: 900px; border: 1px solid #ced4da; border-radius: .25rem;",
                                includeHTML(paste0(www_directory_ui, "/Disclaimer/_site/Disclaimer.html" ))
                            )
                     ),
                     column(2)
                   )
        ))
}



translator <- function() {
  return(tabPanel(title = paste0(site_params$from_language, " to ", site_params$to_language," code Assistant"),
         # Main content ----
         fluidRow(
           column(1),
           column(5,
                  # Progress bar ----
                  attendantBar("progress-bar1",
                               color = "success",
                               max = 100,
                               striped = TRUE,
                               animated = TRUE,
                               height = "40px",
                               width = "75%"
                  ),
                  
                  # Live syntax highlighting input SAS code box ----
                  HTML(str_replace(includeHTML(paste0(www_directory_ui, "/html/TranslatorInput.html" )), "_input_language_", site_params$from_language)),
                  
                  # textOutput("sascode"),
                  
                  # Translate button ----
                  actionButton("process1", paste0("Translate to ", site_params$to_language))
           ),
           column(5,
                  div(id = "output1container", style = "height: 100%;", style = "width: 95%",
                      HTML(paste0("<label>Output ",site_params$to_language," Code:</label>")),
                      div(id = "output1", style = "border: 1px solid #CED4DA; height: 800px",
                          div(id = "response1",
                              aceEditor("api_response1",
                                        height = "798px",
                                        mode = "r",
                                        readOnly = TRUE)
                          ),
                      )
                  )
           ),
           column(1)
         )
  ))
}

explainer <- function(){
  return( tabPanel(title = "Explainer",
                   # Main content ----
                   fluidRow(
                     column(1),
                     column(5,
                            # Progress bar ----
                            attendantBar("progress-bar2",
                                         color = "success",
                                         max = 100,
                                         striped = TRUE,
                                         animated = TRUE,
                                         height = "40px",
                                         width = "75%"
                            ),
                            
                            # Live syntax highlighting input R code box ----
                            div(id = "editing2container", style = "height: 100%",
                                HTML(paste0("<label>Input ",site_params$from_language," Code:</label>")),
                                aceEditor(
                                  outputId = "editing2",
                                  height = "750px",
                                  selectionId = "selection",
                                  mode = "r",
                                  placeholder = paste0("Enter ",site_params$from_language," Code")
                                )
                            ),
                            
                            
                            # Explanation button ----
                            actionButton("process2", "Explain")
                     ),
                     column(5,
                            div(id = "output2container", style = "height: 100%;", style = "width: 95%",
                                HTML("<label>Explanation:</label>"),
                                div(id = "output2", style = "border: 1px solid #CED4DA; height: 800px",
                                    uiOutput("outBox")
                                    #div(id = "response2",
                                    #aceEditor("api_response2",
                                    #height = "798px",
                                    #readOnly = TRUE)
                                    #),
                                )
                            )
                     ),
                     column(1)
                   )
  )
  )
}



fluidPage(
  # Cookies to remember user on popup Terms ----
  HTML('<script src="https://cdn.jsdelivr.net/npm/js-cookie@rc/dist/js.cookie.min.js"></script>'),
  
  # Load cookies script ----
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
  
  # Load CSS & JS script ----
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "Transcompiler.css")
  ),
  tags$body(
    tags$script(src="Transcompiler.js")
  ),
  
  # Initialize Progress bar ----
  theme = bslib::bs_theme(version = 4),
  useAttendant(),
  
  # Branding Image ----
  headerPanel(site_params$title, title = img(id = "branding",
                                                    draggable = "false",
                                                    src = site_params$logo )
  ),
  
  
  # Main tabs ----
  tabsetPanel(
    id="inTabset",
    
    instructions(), 
    translator(), 
    explainer()

   
  )
)


