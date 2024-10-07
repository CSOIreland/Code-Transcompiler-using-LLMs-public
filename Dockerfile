# define args
ARG SITE_DIRECTORY="ai-code-translator"
ARG SITE_PORT=3838
ARG SITE_HOST="0.0.0.0"

# Base R Shiny image
FROM rocker/shiny

# Make a directory in the container
RUN mkdir /home/${SITE_DIRECTORY}

# Set working directory 
WORKDIR /home/${SITE_DIRECTORY}

# Install R dependencies
RUN R -e "install.packages(c('shiny','shinythemes','waiter','shinyAce','future','promises','shinyalert','yaml','stringr', 'openai', 'readr'))"

# Copy the Shiny app code
COPY . .

# Expose the application port
EXPOSE ${SITE_PORT}

# Run the R Shiny app
CMD ["Rscript", "docker.runApp.R"]
