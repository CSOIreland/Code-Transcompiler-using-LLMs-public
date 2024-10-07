# CSO code Translator

## About 
This application is a framework which can be used to translate from one programming language to another (for example the CSO use it to translate SAS to R). The application utilises the OpenAI API to translate the code, however it should be possible to use alternative LLMs from other suppliers with some adjustments to the source code - such changes are outside of the scope of this document.

## Authors

The application has been an ongoing project for a series of interns and graduates, and permanent members at the CSO since 2022. The authors are:

### Intens/Graduates
- Sean Kelly 
- Minh Quach [https://www.linkedin.com/in/qhm/](https://www.linkedin.com/in/qhm/)
- Eva Leahy [https://www.linkedin.com/in/eva-leahy/](https://ie.linkedin.com/in/eva-leahy)
- Sean Browne [https://www.linkedin.com/in/se%C3%A1n-browne-608211286/](https://www.linkedin.com/in/se%C3%A1n-browne-608211286/)

### Permanant staff
- Peter Marsh [https://www.linkedin.com/in/peter-marsh-704180157/](https://www.linkedin.com/in/peter-marsh-704180157/)
- Vytas Vaiciulis
- Vinicus Andrade
- Callum Wilson

## Editing
The CSO is making this configurable version of the code translator available for free. Additional editing and configuration is required to ensure that the translator works for you. Most of the configuring can be done across various files. The name and the specific languages to be translated from/to can be edited in the config.yml file. Specific instructions should be edited in `./www/instructions/Instructions1.txt` and `./www/instructions/Instructions2.txt` - these are the Generative AI prompts used to translate code, a basic prompt has been given to get you started. Note that the out-of-the-box version is for SAS to R.

#### config file 
from the config file you can:
`from_language`, `to_language` define the to/from languages. \
`title` define the title of the app. \
`logo` define the file name of the company logo in ./www/images
`open_ai_key` define the openai api key. \
`open_ai_model` defines the GPT LLM model used
`open_ai_max_tokens` defines the max tokens to allow before parsing to LLM.

`regex` a list of regular expressions to check against for the purposes of ensuring that sensitive data is not sent to OpenAI.

#### update LLM instructions
to update LLM instructions insert your instructions into the www/instructions1.txt and www/instructions2.txt files.
- `instructions1.txt` - this defines the instructions to be given to the OpenAI API for translating code from one language to another
- `instructions2.txt` - this defines the instructions to be given to the OpenAI API to explain the code provided in the 'from language'.

#### update T&Cs
To update T&Cs write your specific T&Cs in R markdown in www/Disclaimer/Disclaimer.rmd and knit to HTML. A html fragment file will be created in www/Disclaimer/_site with your T&Cs which will be included in the Instructions tab of the app.

#### Syntactic Highlighting
The app is designed around SAS to R, as such the out-of-the-box solution is designed to provide syntactic highlighting in text boxes for SAS only, this is provided by prismjs. Please refer to [prismjs.com](https://www.prismjs.com/) for details on how to configure this. This guide does not provide help customising this part of the app. 

## Installation

Installation can be completed in one of 2 ways: via Posit Connect or via Docker.

### Posit Connect
Installation instructions for Posit Connect can be found at [https://docs.posit.co/connect/how-to/publish-shiny-app/](https://docs.posit.co/connect/how-to/publish-shiny-app/).
Installing to Posit Connect can be achieved via one of 3 ways:
  - via RStudio / Posit Workbench using the deploy app feature
  - via Git directly in Posit Connect web ui (requires public git repository)
  - via CICD using Jenkins (or similar) continuous integration tool. Posit supply an overview of this method [https://solutions.posit.co/operations/deploy-methods/ci-cd/jenkins/](https://solutions.posit.co/operations/deploy-methods/ci-cd/jenkins/)
  
### Docker
There are 4 docker related config values available to edit in the config.yml file. \
`docker[port]`: defines the port the docker image runs on \
`docker[host]`: defines the host the docker image runs on \
`docker[path]`: defines the path within the image the app is copied to - and sets the working directory with to this \
`docker[image_name]`: defines the image name \

**note:** if any amendments are made to the application with require additional packages to be installed please append the additional R packages to Dockerfile line 16.

Once updated to your preferences run the docker.createImage.R script on a machine with docker running. Once the docker image has been created a container can be created and started using the following command line:

```docker run -p [port you want to use]:[internal docker port] [name of image defined in 'docker_image_name' config value]```

for example, using the out of the box values this line would be:

```
docker run -p 3838:3838 sas-to-r-translator
```

## Crediting

Please credit CSO Ireland if using / editing this application.






