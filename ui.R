
# don't need to define libraries as they're defined in global.R
# all functionality has been put into global.R ready to be refactored into separate files a necessary "later"


# Open multiple sessions ----
# Error: Cannot create 128 parallel PSOCK nodes. Each node needs one connection, 
# But there are only 124 connections left out of the maximum 128 available on this 
# R installation
# Default: connections aka workers = 128
plan(multisession, workers = 4)


# run the ui function (in global.R) to return the fluidPage object
ui()
