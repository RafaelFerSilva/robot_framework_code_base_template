*** Settings ***
Documentation       Book Store API keywords module for test automation
...
...                 This module contains keywords for interacting with the Book Store API.
...                 It provides functionality for:
...                 - User account management (create, authorize, delete)
...                 - Book listing and retrieval
...                 - API request handling
...
...                 Dependencies:
...                 - RequestsLibrary
...                 - JSONLibrary
...                 - JsonValidator
...                 - FakerLibrary
...                 - String

Library             JSONLibrary
Library             JsonValidator
Library             FakerLibrary
Library             String

Resource            bookStore.pages.resource


*** Variables ***
${BODY}=                    ${EMPTY}
${HEADERS}=                 &{EMPTY}

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
    [Documentation]    Creates a request body with fake user data for Book Store API.
    ...
    ...    Behavior:
    ...    - Generates a random user name using FakerLibrary
    ...    - Creates a dictionary with username and password
    ...    - Sets the body as a test variable ${BODY}
    ${user}=    FakerLibrary.Name

    &{body}=    Create dictionary
    ...    userName=${user}
    ...    password=Asasda!123456
    Set Test Variable    ${BODY}    ${body}

Create Book_Store API Headers
    [Documentation]    Creates standard headers for Book Store API requests.
    ...
    ...    Behavior:
    ...    - Creates a dictionary with accept and Content-Type headers
    ...    - Sets the headers as a suite variable ${HEADERS}
    &{headers}=    Create dictionary
    ...    accept=application/json
    ...    Content-Type=application/json
    Set Suite Variable    ${HEADERS}    ${headers}

Create User Account
    [Documentation]    Creates a new user account in the Book Store API.
    ...
    ...    Behavior:
    ...    - Uses the global ${BODY} and ${HEADERS} variables
    ...    - Expects a 201 status code (Created)
    ...
    ...    Returns:
    ...    - API response object
    ${response}=    Perform a Post on the API    ${SESSION}    ${CREATE_ACCOUNT_EP}    ${BODY}    ${HEADERS}    201
    RETURN    ${response}

Generate User Token
    [Documentation]    Generates an authentication token for a user.
    ...
    ...    Behavior:
    ...    - Uses the global ${BODY} and ${HEADERS} variables
    ...    - Expects a 200 status code
    ...
    ...    Returns:
    ...    - API response object containing the token
    ${response}=    Perform a Post on the API    ${SESSION}    ${GENERATE_TOKEN_EP}    ${BODY}    ${HEADERS}    200
    RETURN    ${response}

Return If User is Autorized
    [Documentation]    Checks if a user is authorized in the Book Store API.
    ...
    ...    Behavior:
    ...    - Uses the global ${BODY} and ${HEADERS} variables
    ...    - Expects a 200 status code
    ...
    ...    Returns:
    ...    - API response object indicating authorization status
    ${response}=    Perform a Post on the API    ${SESSION}    ${USER_AUTORIZED_EP}    ${BODY}    ${HEADERS}    200
    RETURN    ${response}

List all Books
    [Documentation]    Retrieves a list of all books from the Book Store API.
    ...
    ...    Behavior:
    ...    - Uses the global ${HEADERS} variable
    ...    - Expects a 200 status code
    ...
    ...    Returns:
    ...    - API response object containing the list of books
    ${response}=    Get All Books From API    ${HEADERS}
    RETURN    ${response}

List Book by ISBN
    [Documentation]    Retrieves a specific book by its ISBN from the Book Store API.
    ...
    ...    Arguments:
    ...    - isbn: ISBN of the book to retrieve
    ...
    ...    Behavior:
    ...    - Replaces the placeholder in the URL with the provided ISBN
    ...    - Uses the global ${HEADERS} variable
    ...    - Expects a 200 status code
    ...
    ...    Returns:
    ...    - API response object containing the book details
    [Arguments]    ${isbn}
    ${response}=    Get Book By ISBN From API    ${isbn}    ${HEADERS}
    RETURN    ${response}
