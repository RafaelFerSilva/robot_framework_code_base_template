*** Settings ***
Resource    ${EXECDIR}/resources/keywords/core/Environment.keywords.resource
Resource    ${EXECDIR}/resources/keywords/core/BrowserContext.keywords.resource
Resource    ${EXECDIR}/resources/keywords/core/DataBase.keywords.resource


*** Test Cases ***
Should be possible open Site on Mobile
    [Setup]    Define test data    page_pt
    Open The Browser With Config    MOBILE=True
    Get Title    ==    ${LANGUAGE}[home][pageTitle]
    [Teardown]    Close Browser
