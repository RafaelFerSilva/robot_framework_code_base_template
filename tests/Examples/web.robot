*** Settings ***
Resource    ${EXECDIR}/resources/keywords/Environment.keywords.resource
Resource    ${EXECDIR}/resources/keywords/BrowserContext.keywords.resource
Resource    ${EXECDIR}/resources/keywords/DataBase.keywords.resource


*** Test Cases ***
Should be possible open Site
    [Setup]    Define test data    pt
    Open the browser with config
    Get Title    ==    ${LANGUAGE}[DEMOQA]
    [Teardown]    Close Browser
