
# don't need to define libraries as they're defined in global.R
# all functionality has been put into global.R ready to be refactored into separate files a necessary "later"

function(input, output, session) {
  # call server function (found in global.R)
  server(input,output, session)
  
} 


