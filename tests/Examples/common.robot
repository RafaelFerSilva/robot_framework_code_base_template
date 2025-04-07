*** Settings ***
Documentation       Tests for validate common keywords

Library             Collections
Resource            ${EXECDIR}/resources/keywords/Common.keywords.resource

Test Tags           common


*** Test Cases ***
Should Be Possible Read Language Json File based in page item id
    Set language    page_pt
    Log Many    ${LANGUAGE}[home][pageTitle]
    Dictionary Should Contain Key    ${LANGUAGE}[home]    pageTitle

Should Be Possible Read Language Json File based string values
    Set language    pt
    Log Many    ${LANGUAGE}[DEMOQA]

Should be possible return a file path
    ${file_path}=    Return the file path from the files folder    i18n    pt.json
    Should Be Equal    ${file_path}    ${RESOURCES_FILES}/i18n/pt.json

Should be possible return a file contents
    ${content}=    Return the contents of a file for testing - utf-8    i18n    pt.json
    Should Be String    ${content}

Should be possible return an erro if file not exists
    ${status}=    Run Keyword And Return Status    Return the contents of a file for testing - utf-8    i18n    xablau
    Should Not Be True    ${status}

Should be possible Split a string and return the number of items
    ${value}=    Split a string and return the number of items    teste-teste    separator=-
    Should Be Equal As Integers    ${value}    2

Should be possible Remove parentheses spaces dots slashes and hyphens from a string
    ${value}=    Remove parentheses spaces dots slashes and hyphens from a string    teste -teste// \\teste..
    Should Be Equal As Strings    ${value}    testeteste\\teste

Should be possible Remove dots from a string
    ${value}=    Remove dots from a string    tes.te...teste
    Should Be Equal As Strings    ${value}    testeteste

Should be possible Remove comma from a string
    ${value}=    Remove comma from a string    test,te,stes
    Should Be Equal As Strings    ${value}    testtestes
