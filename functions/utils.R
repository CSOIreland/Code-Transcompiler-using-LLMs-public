

#######################################################################################
#  Utils abstract away as much as is practical away from ui.R , server.R and global.R
# 
# TODO: add other authors
# Authors: Peter Marsh 
# 
# Created: 03/10/2024 - Peter Marsh
# Edited: 
#
#
#
#
#
#######################################################################################


library(shiny)
library(shinythemes)
library(waiter)
library(shinyAce)
library(future)
library(promises)
library(shinyalert)
library(yaml)
library(stringr)
library(readr)


# this took longer than it should
# I'm not doing this for Server related functions

####################################################################################################
#                                                                                                  #
#  U       U IIIII      FFFFFFF U       U N     N   CCCCC  TTTTTTT IIIII   OOOO   N     N   SSS    #
#  U       U   I        F       U       U NN    N  C     C    T      I    O    O  NN    N  S   S   #
#  U       U   I        F       U       U N N   N C           T      I   O      O N N   N S     S  #
#  U       U   I        F       U       U N N   N C           T      I   O      O N N   N S        #
#  U       U   I        FFFFF   U       U N  N  N C           T      I   O      O N  N  N  S       #
#  U       U   I        F       U       U N  N  N C           T      I   O      O N  N  N   SSS    #
#  U       U   I        F       U       U N   N N C           T      I   O      O N   N N      S   #
#  U       U   I        F       U       U N   N N C           T      I   O      O N   N N       S  #
#  U       U   I        F       U       U N    NN C           T      I   O      O N    NN S     S  #
#   U     U    I        F        U     U  N    NN  C     C    T      I    O    O  N    NN  S   S   #
#    UUUUU   IIIII      F         UUUUU   N     N   CCCCC     T    IIIII   OOOO   N     N   SSS    #
#                                                                                                  #
####################################################################################################

# TODO parse out remaining inline html and inline styling

# defines Instructions panel
instructions <- function(){
  return (tabPanel("Instructions",
                   fluidRow(
                     column(2),
                     column(8,
                            div(id = "disclaimer", 
                                readFile("html", "Disclaimer", "html" )
                            )
                     ),
                     column(2)
                   )
  ))
}

# defines the code translator tab
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
                           HTML(
                             str_replace(
                               readFile("html", "TranslatorInput", "html"),
                               "_input_language_", 
                               site_params$from_language)),
                           
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


# defines the code explainer tab
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

