#'
#' terms and conditions
#' 
#' Calls the terms and conditions popup for new users 
#' and for users who's cookies have expired
#' 
#' @param input global input variable from server.R
#' @export
termsandconditions <- function(input){
  #print(input)
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
}