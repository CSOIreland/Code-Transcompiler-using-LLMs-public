holderMaker <- setRefClass("textHolder", # for storing the api_response update history as a stack
                           fields = list(
                             currentIndex = "integer",
                             editHistory = "list",
                             nextIndex = "integer" # the next index to use when adding things to editHistory
                           ),
                           methods = list(
                             append = function(code){
                               print("textHolder$append marker 0")
                               if (nextIndex <= length(editHistory)){
                                 for (i in nextIndex:length(editHistory)) {editHistory[i] <<- NULL}
                                 }
                               print("textHolder$append marker 1")
                               if (length(editHistory)==0L) {
                                 print("editHistory length 0")
                                 editHistory <<- list(code)
                                 print("overwrote null editHistory")
                                 }
                               else {
                                 print("editHistory length > 0")
                                 editHistory[[nextIndex]] <<- code
                                 print("appended to non-null editHistory")
                                 }
                               print("textHolder$append marker 2")
                               currentIndex <<- length(editHistory)
                               print(paste0("textHolder$append marker 3. currentIndex: ", currentIndex))
                               nextIndex <<- currentIndex + 1L
                               return(editHistory[[currentIndex]])
                             },
                             hello = function(){
                               print("hello!")
                               print(paste0("currentIndex: ", currentIndex))
                               print(paste0("nextIndex: ", nextIndex))
                               print(paste0("editHistory length: ", length(editHistory)))
                             },
                             returnCurrent = function(){
                               if (currentIndex >= 1L) return(editHistory[[currentIndex]])
                               else return("")
                             },
                             stepBack = function(){
                               if (currentIndex < 1L) return("")
                               currentIndex <<- currentIndex - 1L
                               nextIndex <<- nextIndex - 1L
                               if (currentIndex == 0L) return("")
                               return(editHistory[[currentIndex]])
                             },
                             stepForward = function(){
                               if (length(editHistory) == 0) return("")
                               if (currentIndex == length(editHistory)) return(editHistory[[currentIndex]])
                               currentIndex <<- currentIndex + 1L
                               nextIndex <<- nextIndex + 1L
                               return(editHistory[[currentIndex]])
                             },
                             wipe = function(){
                               currentIndex <<- 0L
                               editHistory <<- list()
                               nextIndex <<- 1L
                             }
                           )
)