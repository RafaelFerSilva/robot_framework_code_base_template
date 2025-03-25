*** Settings ***
Resource        ${EXECDIR}/resources/keywords/Book_Store/bookStore.keywords.resource

Suite Setup     Run Keywords    Create Session    ${SESSION}    ${DEMOQA_URL}    disable_warnings=${DISABLED_WORNINGS}    AND
...                 Create Book_Store API Headers


*** Test Cases ***
Should be possible create a user
    [Setup]    Create Book_Store request Body with a Fake User Data
    ${response}=    Create User Account
    Validate Jsonschema From File    ${response.json()}    ${EXECDIR}/resources/files/jsonSchema/createdUser.json
    Should Be Equal As Strings    ${response.json()["username"]}    ${BODY}[userName]

Should be possible generate a user token
    [Setup]    Create Book_Store request Body with a Fake User Data
    Create User Account
    ${response}=    Generate User Token
    Validate Jsonschema From File    ${response.json()}    ${EXECDIR}/resources/files/jsonSchema/generatedToken.json
    Should Be Equal As Strings    ${response.json()["status"]}    Success
    Should Be Equal As Strings    ${response.json()["result"]}    User authorized successfully.

Should be return True if user was autorized
    [Setup]    Create Book_Store request Body with a Fake User Data
    Create User Account
    Generate User Token
    ${response}=    Return If User is Autorized
    Should Be True    ${response.json()}

Should be possible list all books
    ${books}=    List all Books
    Validate Jsonschema From File    ${books.json()}    ${EXECDIR}/resources/files/jsonSchema/listBooks.json

Should be possible list a book by ISBN
    ${book}=    List Book by ISBN    9781449365035
    Validate Jsonschema From File    ${book.json()}    ${EXECDIR}/resources/files/jsonSchema/listBookISBN.json
    Should Be Equal As Strings    ${book.json()["isbn"]}    ${BOOK_DATABASE_DATA}[isbn]
    Should Be Equal As Strings    ${book.json()["title"]}    ${BOOK_DATABASE_DATA}[title]
    Should Be Equal As Strings    ${book.json()["subTitle"]}    ${BOOK_DATABASE_DATA}[subTitle]
    Should Be Equal As Strings    ${book.json()["author"]}    ${BOOK_DATABASE_DATA}[author]
    Should Be Equal As Strings    ${book.json()["pages"]}    ${BOOK_DATABASE_DATA}[pages]
    Should Be Equal As Strings    ${book.json()["description"]}    ${BOOK_DATABASE_DATA}[description]
