# CSO code Translator

## About 
This application is a framework which can be used to translate from one programming language to another (for example the CSO use it to translate SAS to R). The application utilises the OpenAI API to translate the code, however it should be possible to use alternative LLMs from other suppliers with some adjustments to the source code - such changes are outside of the scope of this document.

## Authors

The application has been an ongoing project for a series of interns and graduates, and permanent members at the CSO since 2022. The authors are:

### Interns/Graduates
- Sean Kelly 
- Minh Quach [https://www.linkedin.com/in/qhm/](https://www.linkedin.com/in/qhm/)
- Eva Leahy [https://www.linkedin.com/in/eva-leahy/](https://ie.linkedin.com/in/eva-leahy)
- Sean Browne [https://www.linkedin.com/in/se%C3%A1n-browne-608211286/](https://www.linkedin.com/in/se%C3%A1n-browne-608211286/)
- Cian O'Riordan [https://ie.linkedin.com/in/cian-o-riordan-960a30211](https://ie.linkedin.com/in/cian-o-riordan-960a30211)
- Oliver Milne [https://ie.linkedin.com/in/oliver-milne-84b11970](https://ie.linkedin.com/in/oliver-milne-84b11970)

### Permanent staff
- Peter Marsh [https://www.linkedin.com/in/peter-marsh-704180157/](https://www.linkedin.com/in/peter-marsh-704180157/)
- Vytas Vaiciulis 
- Vinicius Andrade
- Callum Wilson

## User Interface
There are four tabs: Instructions, SAS to R Code Assistant, Explainer, and SPSS to R Code Assistant. The first and third of these are self-explanatory. The assistant tabs are a little more complicated. Both of them work the same way, they just accept different input languages.

The left half of each assistant tab is where the user puts in their inputs. At the top, there is a box for the code to be translated; below that, a box for additional translation instructions; at the bottom, 'Update Translation', 'Undo', 'Redo', and 'Translate' buttons, plus a slider.

To translate a piece of code, copy it into the top input box, add additional instructions in the lower input box if you like, and hit 'Translate'. 

![Transcompiler operations no logo](https://github.com/user-attachments/assets/a2ace927-9e86-4e29-b0d8-aca7b398423f)

You can adjust the slider to change the maximum number of times the translator will send the translation back for corrections before serving it to you; the higher the number, the better quality the output will tend to be, but the longer it will take (each check is another two calls to the LLM).

![self_checker_adjustment](https://github.com/user-attachments/assets/e7fea9e1-efda-4fbc-b68e-9c2bc8ffe990)

Once you have some translated code in the right-hand panel, you can have the LLM edit it by putting appropriate instructions in the 'Additional Instructions' input box and hitting 'Update Translation'. This makes a single call to the LLM, telling it to copy out the contents of the output pane and make edits in accord with the instructions. It doesn't reference the original code at all. This lets you refine what you already have, unlike hitting 'Translate', which wipes the slate clean and does a fresh translation.

![Update translation no logo](https://github.com/user-attachments/assets/4cad9082-f26f-4d3f-98a9-a22a714af9a7)

The 'Undo' and 'Redo' buttons affect the output pane, and let you move back and forth between outputs. Note that this works with the same logic of 'undo/redo' as other desktop software, so if you go back in the sequence and then do something else from there, the steps ahead of where you were in the sequence will be lost.

![Undo redo no logo](https://github.com/user-attachments/assets/e68e9d14-614e-410b-aef4-7961bac0b734)

The 'Give feedback' button lets you send an email to an address set in the config file.

## Editing
The CSO is making this configurable version of the code translator available for free. Additional editing and configuration is required to ensure that the translator works for you. Most of the configuring can be done across various files. The name and the specific languages to be translated from/to can be edited in the config.yml file. Specific instructions should be edited in the text files in the `./www/instructions` folder - these are the Generative AI prompts used to translate and update code, a basic prompt has been given to get you started. Note that the out-of-the-box version is for SAS to R. The colour scheme can be edited using the .css files under `./www/includes`.

#### Using a different LLM
This version of the transcompiler uses the Ellmer package. This allows you to use LLMs from a variety of different providers. By default, it is set up to use the OpenAI API. To use a different provider, you will need to edit R/runChatCompletion.R, as well as add the relevant parameters to the config file.

#### Config file 
Most of your important configuration stuff can be done via the config file, including:
`from_language`, `to_language` define the to/from languages. \
`title` define the title of the app. \
`logo` define the file name of the company logo in ./www/images
`open_ai_key` define the openai api key. \
`open_ai_model` defines the GPT LLM model used
`open_ai_max_tokens` defines the max tokens to allow before parsing to LLM.

`regex` a list of regular expressions to check against for the purposes of ensuring that sensitive data is not sent to OpenAI.

This is not an exhaustive list, check the file itself for further information.

#### Update LLM instructions
There are four kinds of instruction file in the .\www\instructions folder. The numbers at the end of the file names correspond to the tab they're used for, so instructions1 is used by the first tab from the left, for example.

'instructions' files provide initial translation instructions, used when you click 'Translate'.
- `instructions1.txt` - this defines the instructions to be given to the OpenAI API for translating code from one language to another
- `instructions2.txt` - this defines the instructions to be given to the OpenAI API to explain the code provided in the 'from language'.
- `instructions3.txt` - this defines the instructions to be given to the OpenAI API for translating from SPSS to R.

'checkerInstructions' files provide instructions to check the code returned by the LLM before it is served to the user.

'correctorInstructions' files provide instructions to correct code the checker has decided is not adequate.

'manualIteratorInstructions' provides instructions for what to do to the returned code when the user clicks 'Update Translation'. 'Update Translation' ignores what is in the input box, and only pays attention to the output and 'Additional Instructions' boxes. These instructions are shared by all tabs with this functionality, so there's only one manualIteratorInstructions file.

#### update T&Cs
To update T&Cs write your specific T&Cs in R markdown in www/Disclaimer/Disclaimer.rmd and knit to HTML. A html fragment file will be created in www/Disclaimer/_site with your T&Cs which will be included in the Instructions tab of the app.

#### Syntactic Highlighting
The app is designed around SAS to R, as such the out-of-the-box solution is designed to provide syntactic highlighting in text boxes for SAS, SPSS and R. This is provided by prismjs and shinyAce. shinyAce's AceEditor provides a variety of language support - check the package's documentation for guidance. Please refer to [prismjs.com](https://www.prismjs.com/) for details on how to configure prismJS.

## Installation

Installation can be completed in one of 2 ways: via Posit Connect or via Docker.

### Posit Connect
Installation instructions for Posit Connect can be found at [https://docs.posit.co/connect/how-to/publish-shiny-app/](https://docs.posit.co/connect/how-to/publish-shiny-app/).
Installing to Posit Connect can be achieved via one of 3 ways:
  - via RStudio / Posit Workbench using the deploy app feature
  - via Git directly in Posit Connect web ui (requires public git repository)
  - via CICD using Jenkins (or similar) continuous integration tool. Posit supply an overview of this method [https://solutions.posit.co/operations/deploy-methods/ci-cd/jenkins/](https://solutions.posit.co/operations/deploy-methods/ci-cd/jenkins/)
  
### Docker
**The CSO is not responsible for any problems you encounter using Docker.**
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






