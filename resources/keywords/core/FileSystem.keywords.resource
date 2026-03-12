*** Settings ***
Documentation     File System handling module for the test automation framework
...               
...               This module deals with retrieving and loading files from the /files directory.
...               It provides functionality for:
...               - Finding internal file paths
...               - Loading content with utf-8-sig encoding strictness

Resource          ${EXECDIR}/resources/keywords/core/Strings.keywords.resource

Library           OperatingSystem
Variables         ${EXECDIR}/resources/config_variables.py


*** Variables ***
${RESOURCES}            ${EXECDIR}/resources
${RESOURCES_FILES}      ${RESOURCES}/files


*** Keywords ***
Return The File Path From The Files Folder
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
    ...    |    ${file_path}=    |    Return The File Path From The Files Folder    |    i18n    |    language_pt.json    |
    [Arguments]    ${folder}    ${file_name}
    ${path}=    Replace String    ${RESOURCES_FILES}/$$/$$    $$    ${folder}    count=1
    ${path}=    Replace String    ${path}    $$    ${file_name}    count=1
    RETURN    ${path}

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
    ${file_path}=    Return The File Path From The Files Folder    ${folder}    ${file_name}
    ${file}=    Get File    ${file_path}    encoding='utf-8-sig'    encoding_errors=strict
    RETURN    ${file}
