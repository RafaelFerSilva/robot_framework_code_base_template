*** Settings ***
Resource    ${EXECDIR}/resources/keywords/Common.keywords.resource
Resource    ${EXECDIR}/resources/keywords/DataBase.keywords.resource


*** Test Cases ***
Should be possible open Site on Mobile
    [Setup]    Define test data by language    PT
    Open the browser with config    MOBILE=True
    Get Title    ==    ${LANGUAGE}[DEMOQA]
    [Teardown]    Close Browser
