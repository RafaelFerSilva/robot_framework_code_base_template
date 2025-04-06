*** Settings ***
Documentation     Database keywords module for test automation
...               
...               This module contains keywords related to database operations.
...               It provides functionality for:
...               - Setting up database connections
...               - Executing SQL queries
...               - Working with SQL files
...               
...               Dependencies:
...               - DatabaseLibrary
...               - Collections
...               - OperatingSystem
...               - String

Library             DatabaseLibrary
Library             Collections
Library             OperatingSystem
Library             String
Resource            ./Common.keywords.resource


*** Variables ***
${LOCAL_SQL_FOLDER}=    ${EXECDIR}/resources/sql/


*** Keywords ***
Set Database data
    [Documentation]    Configures database connection parameters for test execution.
    ...    Sets up the database access data as a global variable.
    ...    Typically used within 'Define test data by campaign'.
    ...
    ...    Arguments:
    ...    - db_name: Database name
    ...    - db_user: Database username
    ...    - db_password: Database password
    ...    - db_host: Database host
    ...    - db_port: Database port
    ...    - db_module: Database API module name
    ...
    ...    Returns:
    ...    - Sets the global variable ${DATABASE} with connection parameters
    ...
    ...    Example:
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
    [Documentation]    Establishes a database connection based on environment variables.
    ...    For setting environment variables, use "Set Environment Variables" from 
    ...    ${EXECDIR}/resources/libraries/DotEnv.py library before using this keyword.
    ...
    ...    Arguments:
    ...    - env: Environment to connect to (default: value of global variable ${ENVIRONMENT})
    ...
    ...    Behavior:
    ...    - Uses environment variables to set up database connection parameters
    ...    - Connects to the database using DatabaseLibrary
    ...
    ...    Example:
    ...    |    Connect to application database    |
    ...
    ...    Returns:
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
    ...    ${DB_API_MODULE_NAME}

    Connect To Database
    ...    db_module=${DATABASE}[DB_API_MODULE_NAME]
    ...    db_name=${DATABASE}[DB_NAME]
    ...    db_user=${DATABASE}[DB_USER]
    ...    db_password=${DATABASE}[DB_PASSWORD]
    ...    db_host=${DATABASE}[DB_HOST]
    ...    db_port=${DATABASE}[DB_PORT]

Perform a database query
    [Documentation]    Executes a SQL query on the connected database.
    ...    Performs a return validation. When nothing is returned, this keyword executes Skip in test.
    ...
    ...    Arguments:
    ...    - query: SQL query to execute
    ...    - asDict: Flag to return results as dictionary (default: ${True})
    ...
    ...    Returns:
    ...    - Query results
    ...
    ...    Example:
    ...    |    ${response_query}    |    Perform a database query    |    SELECT * FROM Table    |
    [Arguments]    ${query}    ${asDict}=${True}

    ${response_query}=    Query    select_statement=${query}    return_dict=${asDict}
    Log Many    ${response_query}
    RETURN    ${response_query}

Return the contents of the sql local query file and perform the query in the database
    [Documentation]    Executes a SQL query from a local file.
    ...    SQL scripts are stored in resources/sql/${ENVIRONMENT}
    ...
    ...    Arguments:
    ...    - sql_file_name: Name of the file containing the query to be executed
    ...    - replace_strings: Strings to replace in file content if necessary (default: replace $$ with the list values)
    ...    - asDict: Flag to return results as dictionary (default: True)
    ...
    ...    Returns:
    ...    - Query results
    ...
    ...    Example:
    ...    Read a local query and execute:
    ...    |    ${result}=    |    Return the contents of the sql local query file and perform the query in the database    |    file.sql    |    A    B    C    |
    [Arguments]    ${sql_file_name}    @{replace_strings}    ${asDict}=True

    ${template}=    Get File    ${LOCAL_SQL_FOLDER}/${sql_file_name}
    ${element}=    String Replace    ${template}    @{replace_strings}
    ${item}=    Perform a database query    ${element}    ${asDict}

    RETURN    ${item}
