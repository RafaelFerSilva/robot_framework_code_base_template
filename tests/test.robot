*** Settings ***

Resource    ${EXECDIR}/resources/keywords/Common.resource

*** Test Cases ***
Should be possible open Site
    [Setup]    Define test data by language   PT    
    Open the browser with config
    Get Title    ==    ${LANGUAGE}[DEMOQA]
    [Teardown]    Close Browser