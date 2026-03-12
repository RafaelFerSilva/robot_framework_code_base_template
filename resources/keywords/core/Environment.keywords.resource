*** Settings ***
Documentation     Environment keywords module for the test automation framework
...               
...               This module manages global test environment configuration, including:
...               - Language definition
...               - Environment URL routing
...               - Test data initialization

Library             Collections
Library             JSONLibrary
Variables           ${EXECDIR}/resources/config_variables.py


*** Variables ***
${RESOURCES}            ${EXECDIR}/resources
${RESOURCES_FILES}      ${RESOURCES}/files


*** Keywords ***
Set language
    [Documentation]    Configures the language for tests by loading a JSON language dictionary file.
    ...
    ...    The file must be located in resources/files/i18n/ with the name in the format [language].json
    ...
    ...    Arguments:
    ...    - file_name: Language file name (default: value of global variable ${LANG})
    ...
    ...    Returns:
    ...    - Sets the global variable ${LANGUAGE} with the loaded language dictionary
    ...
    ...    Example:
    ...    |    Set language    PT
    [Arguments]    ${file_name}=${LANG}

    ${FILE}=    Load Json From File    ${RESOURCES_FILES}/i18n/${file_name}.json    utf-8
    ${LANGUAGE_DIC}=    Convert To Dictionary    ${FILE}
    Set Global Variable    ${LANGUAGE}    ${LANGUAGE_DIC}

Set test URL
    [Documentation]    Sets the test URL based on the specified environment.
    ...
    ...    Arguments:
    ...    - env: Test environment (default: value of global variable ${ENVIRONMENT})
    ...
    ...    Returns:
    ...    - Sets the global variable ${URL} with the URL corresponding to the environment
    [Arguments]   ${env}=${ENVIRONMENT}

    VAR    ${URL}    ${URLS}[${env}]
    Set Global Variable    ${URL}    ${URLS}[${env}]

Define test data
    [Documentation]    Configures test data by identifying language and URL for test execution.
    ...    This keyword should preferably be used before executing the test suites.
    ...
    ...    Arguments:
    ...    - set_language_file_name: Language file name (default: value of global variable ${LANG})
    ...    - env: Test environment (default: value of global variable ${ENVIRONMENT})
    ...
    ...    Example:
    ...    | Define test data |    PT    |
    [Arguments]    ${set_language_file_name}=${LANG}    ${env}=${ENVIRONMENT}

    Set test URL    ${env}
    Set language    ${set_language_file_name}
