*** Settings ***
Documentation     File System handling module for the test automation framework
...               
...               This module deals with retrieving and loading files from the /files directory.
...               It provides functionality for:
...               - Finding internal file paths
...               - Loading content with utf-8-sig encoding strictness

Resource          ${EXECDIR}/resources/keywords/Strings.keywords.resource

Library           String
Library           OperatingSystem
Variables         ${EXECDIR}/resources/config_variables.py


*** Variables ***
${RESOURCES}            ${EXECDIR}/resources
${RESOURCES_FILES}      ${RESOURCES}/files


*** Keywords ***
Return the file path from the files folder
    [Documentation]    Returns a file path to be used in tests.
    ...    This keyword does not validate whether the file exists, it only creates a path based on the framework's file folder path.
    ...
    ...    Arguments:
    ...    - folder: Folder inside the files folder
    ...    - file: File name
    ...
    ...    Returns:
    ...    - Complete file path
    ...
    ...    Example:
    ...    |    ${file_path}=    |    Return the file path from the files folder    |    i18n    |    language_pt.json    |
    [Arguments]    ${folder}    ${file}
    ${file}=    String Replace    ${RESOURCES_FILES}/$$/$$    $$    ${folder}    count=1
    ${file}=    String Replace    ${file}    $$    ${file}    count=1
    RETURN    ${file}

Return the contents of a file for testing - utf-8
    [Documentation]    Returns the content of a file inside the resource files folder.
    ...
    ...    Arguments:
    ...    - folder: Folder inside the files folder
    ...    - file_name: File name
    ...
    ...    Returns:
    ...    - File content
    ...
    ...    Example:
    ...    |    ${content}=    |    Return the contents of a file for testing - utf-8    |    i18n    |    language_pt.json    |
    [Arguments]    ${folder}    ${file_name}
    ${file_path}=    Return the file path from the files folder    ${folder}    ${file_name}
    ${file}=    Get File    ${file_path}    encoding='utf-8-sig'    encoding_errors=strict
    RETURN    ${file}
