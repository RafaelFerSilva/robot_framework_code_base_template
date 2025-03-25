*** Settings ***
Documentation    Keywords for work to JSON files

Library         JsonValidator
Library         JSONLibrary
Resource       ./Common.keywords.resource

*** Keywords **
    
Validate API Json Schema From File
    [Arguments]     ${response_json}    ${folder}       ${schema_json}
    ${file_path}=    Return the file path from the files folder      jsonSchema/${folder}       ${schema_json}
    Validate Jsonschema From File	  ${response_json}   ${file_path}
