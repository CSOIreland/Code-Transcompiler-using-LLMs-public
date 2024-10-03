# this app is used by the docker image to run app within a docker container
# it uses the docker parameters provided by the yaml file and runs the app
# this is to support differing port and host numbers within a docker container.

site_params <- yaml::read_yaml(paste0(getwd(), "/config.yml"))

site_port <- site_params$docker$port
site_host <- site_params$docker$host

# run app using port and host defined in config file
shiny::runApp(paste0(getwd(), host=site_host, port=site_port))

