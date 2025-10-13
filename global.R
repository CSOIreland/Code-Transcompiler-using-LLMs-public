# define libraries used throughout the app
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

#load readFile first
source (paste0(getwd(), "/R/readFile.R"))

# read the params file
site_params <- readFile("yaml", "config")

# load other functions
loadSupport("R")

# load order:
# 1. global.R
# 2. all files in R/ (in alphabetical order)
# 3. server.R & ui.R