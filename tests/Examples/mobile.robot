*** Settings ***
Resource    ${EXECDIR}/resources/keywords/Environment.keywords.resource
Resource    ${EXECDIR}/resources/keywords/BrowserContext.keywords.resource
Resource    ${EXECDIR}/resources/keywords/DataBase.keywords.resource


*** Test Cases ***
Should be possible open Site on Mobile
    [Setup]    Define test data    page_pt
    Open the browser with config    MOBILE=True
    Get Title    ==    ${LANGUAGE}[home][pageTitle]
    [Teardown]    Close Browser
