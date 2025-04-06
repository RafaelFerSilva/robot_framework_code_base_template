*** Settings ***
Documentation     JSON keywords module for test automation
...               
...               This module contains keywords for working with JSON files.
...               It provides functionality for:
...               - JSON schema validation
...               - JSON file operations
...               
...               Dependencies:
...               - JsonValidator
...               - JSONLibrary

Library         JsonValidator
Library         JSONLibrary
Resource       ./Common.keywords.resource

*** Keywords ***
    
Validate API Json Schema From File
    [Documentation]    Validates a JSON response against a schema file.
    ...
    ...    Arguments:
    ...    - response_json: JSON response to validate
    ...    - folder: Subfolder within jsonSchema directory where the schema file is located
    ...    - schema_json: Name of the schema JSON file
    ...
    ...    Behavior:
    ...    - Locates the schema file in the specified folder
    ...    - Validates the JSON response against the schema
    ...
    ...    Example:
    ...    |    Validate API Json Schema From File    |    ${response}    |    users    |    user_schema.json    |
    [Arguments]     ${response_json}    ${folder}       ${schema_json}
    ${file_path}=    Return the file path from the files folder      jsonSchema/${folder}       ${schema_json}
    Validate Jsonschema From File	  ${response_json}   ${file_path}
