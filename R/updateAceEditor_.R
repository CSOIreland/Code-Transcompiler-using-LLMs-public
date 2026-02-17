updateAceEditor_ <- function(session, editorId, value){
  # print(paste0("debug: updateAceEditor_ called on editorId ",editorId))
  updateAceEditor(session=session, 
                  editorId=editorId,
                  value = value,
                  wordWrap = T)
}