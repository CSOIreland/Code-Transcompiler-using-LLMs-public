# CSO code Translator

## About 
This application is a framework which can be used to translate from one programming language to another (for example the CSO use it to translate SAS to R). The application utilises the OpenAI LLM API to translate the code, however it should be possible to use alternative LLMs from other suppliers with some adjustments to the source code - such changes are outside of the scope of this document.

## Authors

The application has been an ongoing project for a series of interns and graduates at the CSO since 2022 and permanent members of CSO. The authors are:

### Intens/Graduates
- Sean Kelly 
- Minh Quach [https://www.linkedin.com/in/qhm/](https://www.linkedin.com/in/qhm/)
- Eva Leahy [https://www.linkedin.com/in/eva-leahy/](https://ie.linkedin.com/in/eva-leahy)
- Sean Browne [https://www.linkedin.com/in/se%C3%A1n-browne-608211286/](https://www.linkedin.com/in/se%C3%A1n-browne-608211286/)

### Permanant staff
- Peter Marsh
- Vytas Vaiciulis
- Vinicus Andrade
- Callum Wilson

## Editing
The CSO is making this configurable version of the code translator available for free. Additional editing and configuration is required to ensure that the translator works for you. Most of the configuring can be done across various files. The name and the specific languages to be translated from/to can be edited in the config.yml file. Specific instructions should be edited in ./www/Instructions1.txt and ./www/Instructions2.txt - these are the Generative AI prompts used to translate code, a basic prompt has been given to get you started. Note that the out-of-the-box version is for SAS to R.

#### config file 
from the config file you can:
- define the to/from languages (`from_language`, `to_language`) 
- define the title of the app (`title`)
- define the openai api key (`open_ai_key`)
- define the file name of the company logo in www folder (`logo`)

#### update LLM instructions
to update LLM instructions insert your instructions into the www/instructions1.txt and www/instructions2.txt files.
- instructions1.txt - this defines the instructions to be given to the OpenAI LLM API for translating code from one language to another
- instructions2.txt - this defines the instrucitons to be given to the OpenAI LLM API for describing the code provided in the from language.

#### update T&Cs
To update T&Cs write your specific T&Cs in R markdown in www/Disclaimer/Disclaimer.rmd and knit to HTML. A html fragment file will be created in www/Disclaimer/_site with your T&Cs which will be included in the Instructions tab of the app.

#### Syntactic Highlighting
The app is designed around SAS to R, as such the out-of-the-box solution is designed to provide syntactic highlighting in text boxes for SAS only, this is provided by prismjs. Please refer to [prismjs.com](https://www.prismjs.com/) for details on how to configure this. This guide does not provide help customising this part of the app. 


## Crediting

Please credit CSO Ireland if using / editing this application.






