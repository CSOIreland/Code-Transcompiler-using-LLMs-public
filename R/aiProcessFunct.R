# aiProcessFunct
# nice and small
aiProcessFunct <- function(att, 
                           checkerFunct,
                           # dd_editorId, 
                           # dummyDataInstructions="",
                           holder,
                           instructions,
                           lang,
                           session,
                           successFunct,
                           toCheckBool,
                           translator_editorId,
                           # updateFunction,
                           userInput, 
                           userInstructionsInput,
                           ...){ #session, output,language, api
	# loading bar
  att$set(0)    # Start at 0%
	att$auto()
	
	print("")
	print("")
	print("")
	print("aiProcessFunct firing!")
	print("")
	print("")
	print("")
	
	if(!is.null(userInstructionsInput)){
	  userInput <- paste0(
	    userInput,
	    "\n-----ADDITIONAL INSTRUCTIONS-----\n",
	    userInstructionsInput
	  )
	  print("updated userInput")
	}
	
	# if(toCheckBool){
	#   # Let's just do a little test to see that the dd_apiOutput is working
	#   updateAceEditor_(editorId = dd_editorId, 
	#                    session=session,
	#                    value="test\ntest\ntest\ntest\ntest\ntest\ntest")
	#   # print(paste0("did updateFunction. editorId = ", dd_editorId))
	#   }
	
	future({
		# OpenAI API connection ----
		rs <- runChatCompletion(instructions=instructions, userInput=userInput)
		# if(toCheckBool){
		#   dummyData <- runChatCompletion(instructions=dummyDataInstructions, 
		#                                  userInput=userInput)
		# } else{
		#   dummyData <- NULL
		# }
		
		logholder <-  pairlist("rs"=rs#, "dd"=dummyData
		                       )
		# print(logholder)
		# print(rs)
		# print(dummyData) # what's printed is 'named list()'
		return(logholder)
	}) %...>% (
	  function(collectionOfChats # so it seems like this names whatever is returned by the future
    ){
	    print("future delivered by aiProcessFunct")
	    # print(collectionOfChats)
	    # print(paste0(typeof(collectionOfChats),  " ", length(collectionOfChats)))
	    
	    # run the indicated success function 
	    # (it's aiProcessSuccessFunct)
	    if(toCheckBool){
	      checkerFunct(att=att,
	                   # dd_editorId=dd_editorId,
	                   # dummyData=collectionOfChats["dd"], 
	                   holder=holder,
	                   # iterationLimit=1, 
	                   lang=lang,
	                   rs=collectionOfChats["rs"], 
	                   session=session, 
	                   successFunct=successFunct,
	                   translator_editorId=translator_editorId,
	                   # updateFunction=updateFunction, 
	                   userInput=userInput,  
	                   ...) 
	    }
		  else{
		    successFunct(att=att,
		                 code_reconstructed=NULL,
		                 # dd_editorId=dd_editorId,
		                 # dummyData=collectionOfChats["dd"],
		                 end_line=NULL,
		                 holder=holder,
		                 lang=lang,
		                 lines=NULL,
		                 lines2=NULL,
		                 response=collectionOfChats["rs"]$rs$choices$message.content, 
		                 session=session, 
		                 start_line=NULL,
		                 start_sentence=NULL,
		                 translator_editorId = translator_editorId# ,     
		                 # updateFunction=updateFunction
		    ) 
		  }
	  }
	) %...!% (
	  function(collectionOfChats
    ){
	    print(collectionOfChats$message)
		  errorFunct(rs=collectionOfChats, att=att)
	  }
	)	

}


