# Code-Transcompiler-using-LLM-s
## Programming language converter using OpenAI LLM's 
## Description

This R shiny web app was built for the translation of programming languages to other programming languages (transcompilation).
The app offers a simple user interface with no requirement to choose or parameterise the model.
Calls are made to the OpenAI API to translate the inputted code into the chosen language the OpenAI output returned.

Sensitive information such as urls, paths and names are detected and only submitted to OpenAI if the user explicitly consents to sharing
this information. 

## Requirements

The user needs to supply some additional information for the app to run as intended, this can be inputted by editing the .config file.
These required pieces of information are:

AI_INSTRUCTIONS: This will give the model some information about its task, for example "You are a code transcompiler, when given code in LANGUAGE_1, return the equivalent program in LANGUAGE_2".

API_KEY: An OpenAi API key

LANGUAGE_1: This will tell the model which langauge to expect the input to be in

LANGUAGE_2: This will tell the model which langauge to translate the input into

SEARCH_REGEX: The user may want to classify some input information as sensitive, and treat it as descriped above. A Perl regular expression should be chosen to find sensitive information in the input.

LOGO_LOCATION: The user can use an image of their choice for the header, this will be located at the top left corner of the user interface.

## Example

<img width="920" alt="screenshot_sastor_app" src="https://github.com/CSOIreland/Code-Transcompiler-using-LLMs-public/assets/12334028/a9f59a23-ec34-4ca2-ab0c-d7b479fd4769">

