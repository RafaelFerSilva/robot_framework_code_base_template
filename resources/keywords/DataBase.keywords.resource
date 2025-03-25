*** Settings ***
Documentation       Keywords related to use DataBase library module.

Library             DatabaseLibrary
Library             Collections
Library             OperatingSystem
Library             String
Resource            ./Common.keywords.resource


*** Variables ***
${LOCAL_SQL_FOLDER}=    ${EXECDIR}/resources/sql/${ENVIRONMENT}


*** Keywords ***
Set Database data
    [Documentation]    Identifies which database we want to access to perform the tests
    ...    Return the database access data.
    ...    Normally this keyword is used within 'Define test data by campaign'
    ...    = Examples =
    ...    | Set Database data    |    ${db_name}    |    ${db_user}    |    ${db_password}    |    ${db_host}    |    ${db_port}    |    ${db_module}    |
    [Arguments]    ${db_name}    ${db_user}    ${db_password}    ${db_host}    ${db_port}   ${db_module}
    ${database_data}=    Create Dictionary
    ...    DB_NAME=${db_name}
    ...    DB_USER=${db_user}
    ...    DB_PASSWORD=${db_password}
    ...    DB_HOST=${db_host}
    ...    DB_PORT=${db_port}
    ...    DB_API_MODULE_NAME=${db_module}
    Log Many    ${database_data}
    Set Global Variable    ${DATABASE}    ${database_data}

Connect to application database
    [Documentation]    This keyword perform a database connection base on environment variables.
    ...    For set environment variables we need use "Set Environment Variables" of ${EXECDIR}/resources/libraries/DotEnv.py Lib before use "Connect to database"
    ...
    ...    = Examples =
    ...    |    Connect to database    |
    ...    = Return =
    ...    |    Returns the connection based on the global variable ${ENVIRONMENT}
    ...
    ...    As the environment is changed using the ${ENVIRONMENT} variable, the Database connects to the new environment
    [Arguments]    ${env}=${ENVIRONMENT}
    Set Database data
    ...    %{DB_NAME}
    ...    %{DB_USER}
    ...    %{DB_PASSWORD}
    ...    %{DB_HOST}
    ...    %{DB_PORT}
    ...    %{DB_API_MODULE_NAME}

    Connect To Database
    ...    db_module=${DATABASE}[DB_API_MODULE_NAME]
    ...    db_name=${DATABASE}[DB_NAME]
    ...    db_user=${DATABASE}[DB_USER]
    ...    db_password=${DATABASE}[DB_PASSWORD]
    ...    db_host=${DATABASE}[DB_HOST]
    ...    db_port=${DATABASE}[DB_PORT]
    ...    db_charset=UTF8

Perform a database query
    [Documentation]    Receive a SQL query (String) and execute in connected database.
    ...    This keyword perform a return validation. When nothing was returned this keyword execute Skip in test
    ...
    ...    = Examples =
    ...    |    ${response_query}    |    Perform a database query    |    SELECT * FROM Table    |
    [Arguments]    ${query}    ${asDict}=${True}

    ${response_query}=    Query    selectStatement=${query}    returnAsDict=${asDict}
    Log Many    ${response_query}
    RETURN    ${response_query}

Return the contents of the sql local query file and perform the query in the database
    [Documentation]    This keyword aims to execute a query obtained from a local file.
    ...    We salve sql scripts in resources/sql/${ENVIRONMENT}
    ...
    ...    = Arguments =
    ...    - folder_path -> Path to the folder where the file containing the query is located.
    ...    - sql_file_name -> Name of the file containing the query to be executed.
    ...    - replace_strings -> Strings for replace in file content if it's necessary
    ...
    ...    = Examples =
    ...    Read a local query and execute
    ...    |    ${result}=    |    Return the contents of the sql local query file and perform the query in the database    |    folder    |    file.sql    |    A    B    C    |
    ...
    [Arguments]    ${folder_path}    ${sql_file_name}    @{replace_strings}    ${asDict}=True

    ${template}=    Get File    ${LOCAL_SQL_FOLDER}/${folder_path}/${sql_file_name}
    ${element}=    String Replace    ${template}    @{replace_strings}
    ${item}=    Perform a database query    ${element}    ${asDict}

    RETURN    ${item}
