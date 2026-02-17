# define libraries used throughout the app
library(bslib)
library(ellmer)
library(future)
library(mailR)
library(promises)
library(readr)
library(shiny)
library(shinyAce)
library(shinyalert)
library(shinythemes)
library(stringr)
library(waiter)
library(yaml)

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