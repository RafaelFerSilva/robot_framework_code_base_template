*** Settings ***
Documentation       Book Store API Page Object (Abstraction Layer)
...
...                 This module provides the low-level technical interface for the Book Store API.
...                 It handles direct HTTP interactions, endpoints, and raw data mapping.

Library             RequestsLibrary
Library             String

*** Variables ***
${SESSION}=                 Book_Store
${DISABLED_WORNINGS}=       1
${DEMOQA_URL}=              https://demoqa.com
${CREATE_ACCOUNT_EP}=       ${DEMOQA_URL}/Account/v1/User
${GENERATE_TOKEN_EP}=       ${DEMOQA_URL}/Account/v1/GenerateToken
${USER_AUTORIZED_EP}=       ${DEMOQA_URL}/Account/v1/Authorized
${DELETE_USER_EP}=          ${DEMOQA_URL}/Account/v1/User/$$
${LIST_BOOKS_EP}=           ${DEMOQA_URL}/BookStore/v1/Books
${LIS_BOOKS_ISBN_EP}=       ${DEMOQA_URL}/BookStore/v1/Book?ISBN=$$


*** Keywords ***
Perform a Post on the API
    [Arguments]    ${session}    ${resource}    ${body}    ${headers}=${EMPTY}    ${expected_status}=200
    [Documentation]    Technical wrapper for POST requests.
    ${response}=    POST On Session
    ...    ${session}
    ...    ${resource}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=${expected_status}
    RETURN    ${response}

Perform a Delete on the API
    [Arguments]    ${session}    ${resource}    ${headers}=${EMPTY}    ${expected_status}=200
    [Documentation]    Technical wrapper for DELETE requests.
    ${response}=    DELETE On Session
    ...    ${session}
    ...    ${resource}
    ...    headers=${headers}
    ...    expected_status=${expected_status}
    RETURN    ${response}

Get All Books From API
    [Arguments]    ${headers}=${EMPTY}
    [Documentation]    Technical call to retrieve all books.
    ${response}=    GET On Session    ${SESSION}    ${LIST_BOOKS_EP}    headers=${headers}    expected_status=200
    RETURN    ${response}

Get Book By ISBN From API
    [Arguments]    ${isbn}    ${headers}=${EMPTY}
    [Documentation]    Technical call to retrieve a book by ISBN.
    ${book_resource}=    Replace String    ${LIS_BOOKS_ISBN_EP}    $$    ${isbn}
    ${response}=    GET On Session    ${SESSION}    ${book_resource}    headers=${headers}    expected_status=200
    RETURN    ${response}
