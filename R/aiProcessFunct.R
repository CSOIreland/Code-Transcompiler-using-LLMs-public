# aiProcessFunct
# nice and small
aiProcessFunct <- function(userInput, att, successFunct, instructions, ...){ #session, output,language, api
	# loading bar
  att$set(0)    # Start at 0%
	att$auto()
	future({
		# OpenAI API connection ----
		rs <- runChatCompletion(instructions=instructions, userInput=userInput)
	}) %...>% (
	  function(rs){
	    # run the indicated success function 
	    # (currently either explanationSuccessFunct, or translateSuccessFunct)
		  successFunct(rs=rs, att=att, ...) 
	  }
	) %...!% (
	  function(rs){
		  errorFunct(rs=rs, att=att)
	  }
	)	

}


