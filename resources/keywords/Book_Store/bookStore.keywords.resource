*** Settings ***
Library     RequestsLibrary
Library     JSONLibrary
Library     JsonValidator
Library     FakerLibrary
Library     String


*** Variables ***
${SESSION}=                 Book_Store
${DISABLED_WORNINGS}=       1
${DEMOQA_URL}=              https://demoqa.com
${CREATE_ACCOUNT}=          ${DEMOQA_URL}/Account/v1/User
${GENERATE_TOKEN}=          ${DEMOQA_URL}/Account/v1/GenerateToken
${USER_AUTORIZED}=          ${DEMOQA_URL}/Account/v1/Authorized
${DELETE_USER}=             ${DEMOQA_URL}/Account/v1/User/$$
${LIST_BOOKS}=              ${DEMOQA_URL}/BookStore/v1/Books
${LIS_BOOKS_ISBN}=          ${DEMOQA_URL}/BookStore/v1/Book?ISBN=$$

&{BOOK_DATABASE_DATA}=
...                         isbn=9781449365035
...                         title=Speaking JavaScript
...                         subTitle=An In-Depth Guide for Programmers
...                         author=Axel Rauschmayer
...                         publish_date=2014-02-01T00:00:00.000Z
...                         publisher=O'Reilly Media
...                         pages=460
...                         description=Like it or not, JavaScript is everywhere these days-from browser to server to mobile-and now you, too, need to learn the language or dive deeper than you have. This concise book guides you into and through JavaScript, written by a veteran programmer who o
...                         website=http://speakingjs.com/


*** Keywords ***
Create Book_Store request Body with a Fake User Data
    ${user}=    FakerLibrary.Name

    &{body}=    Create dictionary
    ...    userName=${user}
    ...    password=Asasda!123456
    Set Test Variable    ${BODY}    ${body}

Create Book_Store API Headers
    &{headers}=    Create dictionary
    ...    accept=application/json
    ...    Content-Type=application/json
    Set Suite Variable    ${HEADERS}    ${headers}

Perform a Post on the API
    [Arguments]    ${session}    ${resource}    ${body}    ${headers}=${EMPTY}    ${expected_status}=200
    ${response}=    POST On Session
    ...    ${session}
    ...    ${resource}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=${expected_status}
    RETURN    ${response}

Perform a Delete on the API
    [Arguments]    ${session}    ${resource}    ${headers}=${EMPTY}    ${expected_status}=200
    ${response}=    DELETE On Session
    ...    ${session}
    ...    ${resource}
    ...    headers=${headers}
    ...    expected_status=${expected_status}
    RETURN    ${response}

Create User Account
    ${response}=    Perform a Post on the API    ${SESSION}    ${CREATE_ACCOUNT}    ${BODY}    ${HEADERS}    201
    RETURN    ${response}

Generate User Token
    ${response}=    Perform a Post on the API    ${SESSION}    ${GENERATE_TOKEN}    ${BODY}    ${HEADERS}    200
    RETURN    ${response}

Return If User is Autorized
    ${response}=    Perform a Post on the API    ${SESSION}    ${USER_AUTORIZED}    ${BODY}    ${HEADERS}    200
    RETURN    ${response}

List all Books
    ${response}=    GET On Session    ${SESSION}    ${LIST_BOOKS}    ${HEADERS}    200
    RETURN    ${response}

List Book by ISBN
    [Arguments]    ${isbn}
    ${book_resource}=    Replace String    ${LIS_BOOKS_ISBN}    $$    ${isbn}
    ${response}=    GET On Session    ${SESSION}    ${book_resource}    ${HEADERS}    200
    RETURN    ${response}
