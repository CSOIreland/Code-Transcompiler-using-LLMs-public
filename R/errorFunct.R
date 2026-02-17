

errorFunct <- function(rs, att){
  showNotification(paste("Error:", rs$message), type = "error")
  # Hide progress bar
  on.exit({
    att$done()
  })	
  return(NULL)
}
