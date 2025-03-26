*** Settings ***
Documentation       The __init__.robot file is executed before any test suite or group of test suites. It serves as a setup for the suites, ideal for environment, database, etc. configurations.

Library             DatabaseLibrary
Library             ${EXECDIR}/resources/libraries/DotEnv.py
Resource            ${EXECDIR}/resources/keywords/DataBase.keywords.resource

Suite Setup         Run Keywords
...                     Set Environment Project Variables
...                     pipeline=${PIPELINE}
...                     environment=${ENVIRONMENT}
...                     print_variables=True    AND
...                     Connect to application database
Suite Teardown      Disconnect From Database
