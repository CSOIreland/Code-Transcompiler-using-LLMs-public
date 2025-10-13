library(readr)
library(yaml)


#' reads files from various locations
#' @param type the file type
#' @param name the name of the file
#' @param subfolder the subfolder the file is in
#' 
#' @export

readFile <- function(type, name, subfolder = ""){
  ext <- extension(type)
  subfld <- subpath(subfolder)
  switch (type,    
    html = includeHTML(paste0(getwd(), subfld, name, ext)),
    yaml = read_yaml(paste0(getwd(), subfld, name, ext)),
    text = as.character(read_file(paste0(getwd(), subfld, name, ext))),
    txt = as.character(read_file(paste0(getwd(), subfld, name, ext))),
    yml = read_yaml(paste0(getwd(), subfld, name, ext))
  )
}


sourceFile <- function(name){
  source (paste0(getwd(), "/functions/", name))
}

getFile <- function(fileName, type){
  switch(type
    , image = paste0("images/", fileName)
    , style = paste0("includes/", fileName)
    , script = paste0("includes/", fileName)
  )
  
  
}

extension <- function (type){
  switch(type, 
    yaml = ".yml", 
    yml = ".yml", 
    text = ".txt", 
    txt = ".txt",
    html = ".html"
    , ""
  )
}

subpath <- function(subfolder){
  switch (subfolder, 
    www = "/www/", 
    html = "/www/html/",
    images = "/www/images/",
    includes = "/www/includes/",
    instructions = "/www/instructions/",
    "/"
    )
}

