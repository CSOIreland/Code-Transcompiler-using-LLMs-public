runChatCompletion <- function(instructions, userInput){

  return (openai::create_chat_completion(
  # Model used from 10-Nov is the GPT-4 turbo preview. 
  # This model will need to be updated when the preview ends and full release begins
  model = site_params$open_ai_model, 
  
  messages = list(
    list(
      "role" = "system",
      "content" = instructions
    ),
    list(
      "role" = "user",
      "content" = userInput
    )
  ),
  
  temperature = 0,
  
  # max_tokens = 1024, # Controls response length for GPT-4
  max_tokens = site_params$open_ai_max_tokens, # Increased response length for GPT-4 Turbo (context window is x4 times larger)
  
  openai_api_key = getAPIKey())
)}