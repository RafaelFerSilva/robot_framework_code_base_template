*** Settings ***
Library  DatabaseLibrary

Resource    ${EXECDIR}/resources/keywords/DataBase.keywords.resource

Test Tags    database

*** Test Cases ***
Perform a database query
    ${result}  Perform a database query  SHOW DATABASES;
    Log  ${result}

Return the contents of the sql local query file and perform the query in the database
    ${result}=    Return the contents of the sql local query file and perform the query in the database       users.sql
    Log  ${result}

Read sql file, replace values and perform query
    ${result1}=    Return the contents of the sql local query file and perform the query in the database       users_replace.sql       1
    Log  ${result1}
    Should Be Equal As Strings    ${result1}[0][username]    user1

    ${result2}=    Return the contents of the sql local query file and perform the query in the database       users_replace.sql       2
    Log  ${result2}
    Should Be Equal As Strings    ${result2}[0][username]    user2

    ${result3}=    Return the contents of the sql local query file and perform the query in the database       users_replace.sql       3
    Log  ${result3}
    Should Be Equal As Strings    ${result3}[0][username]    user3
    