runChatCompletion <- function(instructions, userInput){
  # create chat
  chat <- ellmer::chat_openai(
    system_prompt = instructions,
    credentials = getAPIKey,
    model = site_params$open_ai_model, 
    params = ellmer::params(temperature = 0, 
                            max_tokens = site_params$open_ai_max_tokens)
  )
  # send userInput to the chat and get a response
  returnText <- chat$chat(userInput)
  
  # take that response and format it for use (this follows the format used by the deprecated openai package)
  choices <- list(message.content = returnText)
  returnList <- list(choices = choices)
  
  return(returnList)
}