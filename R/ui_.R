#' ui function
#' called from ui.R
#' @export

ui_ <- function() {
  return  (fluidPage(
  
    # adds title to browser tab
    title = site_params$title,
    
    # load css and js files
    head(),
  
    # Initialize Progress bar ----
    theme = bslib::bs_theme(version = 4),
    
    useAttendant(),
    
    # Branding Image ----
    headerPanel(site_params$title, 
                title = img(id = "branding",
                            draggable = "false",
                            src = getFile(site_params$logo, "image") 
                )
    ),
    
    
    # Main tabs ----
    tabsetPanel(
      id="inTabset",
      instructions(),
      # sas to R
      pageDualInput(
            fromLanguage = site_params$from_language,  
            inputElement = aceInputShort, 
            outputElement = aceOutput, 
            tabIndex = 1), # not obvious to me why this was standardInput
      # explainer
      page_(fromLanguage = site_params$from_language, tabIndex = 2,
            tabName = "Explainer", 
            outputLabel = "Explanation",
            buttonLabel = "Explain", 
            outputElement = aceOutput,  inputElement = aceInput
          ),
      # spss to R
      pageDualInput(fromLanguage = site_params$from_language_2, tabIndex = 3,  
            outputElement = aceOutput,  inputElement = aceInputShort)
      
    ),
   
  ))
}