*** Settings ***
Resource    ${EXECDIR}/resources/keywords/Common.keywords.resource
Resource    ${EXECDIR}/resources/keywords/DataBase.keywords.resource


*** Test Cases ***
Should be possible open Site
    [Setup]    Define test data by language    PT
    Open the browser with config
    Get Title    ==    ${LANGUAGE}[DEMOQA]
    [Teardown]    Close Browser
