# creates docker image using values defined in yml file

library(yaml)

site_params <- read_yaml("config.yml")

site_port <- site_params$docker$port
site_host <- site_params$docker$host
site_path <- site_params$docker$path
image_name <- site_params$docker$image_name

# creates image by running the command line for docker build passing in argumens defined in yaml file
system2(command = "docker", 
        args = c(
          "build",
          "-t",
          image_name,
          "--build-arg",
          paste0("SITE_DIRECTORY=",site_path) ,
          paste0("SITE_PORT=",site_port),
          paste0("SITE_HOST=",site_host),
          "."
        )
      )

# once this R Script is run run/create the container using
# docker run -p 3838:3838 sas-to-r-translator


