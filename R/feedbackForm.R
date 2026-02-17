# UI script to be called when the 'Give feedback' button is clicked
feedbackForm <- function(){
  showModal(
    modalDialog(
      div(
        id = "feedbackFormDiv",
        style = "height: 200px",
        aceEditor(
          outputId = "feedbackOutput",
          height = "100%",
          highlightActiveLine = FALSE,
          selectionId = "selection",
          fontSize= "15",
          mode = "plain_text",
          placeholder = paste0("Send us your feedback!"),
          showLineNumbers = FALSE,
          wordWrap = TRUE
        )
      ),
      footer = tagList(
        actionButton('submitFeedback', 'Submit'),
        modalButton('Cancel')
      ),
      easyClose = TRUE
    )
  )}

# Corresponding backend script to deliver the feedback and close the modal
sendFeedback <- function(input){
  # This produce the following error:
  # Warning: Error in ._jobjRef_dollar: no field, method or inner class called 'parent' 
  send.mail(
    from = site_params$feedback_from_email,
    to = site_params$feedback_to_email,
    subject = "Translator Feedback",
    body = input$feedbackOutput,
    smtp=list(host.name = site_params$feedback_host_name)
  )
  removeModal()
}