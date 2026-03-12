*** Settings ***
Resource    ${EXECDIR}/resources/keywords/core/Environment.keywords.resource
Resource    ${EXECDIR}/resources/keywords/core/BrowserContext.keywords.resource
Resource    ${EXECDIR}/resources/keywords/core/DataBase.keywords.resource


*** Test Cases ***
Should be possible open Site
    [Setup]    Define test data    pt
    Open The Browser With Config
    Get Title    ==    ${LANGUAGE}[DEMOQA]
    [Teardown]    Close Browser
