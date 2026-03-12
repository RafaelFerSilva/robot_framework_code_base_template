*** Settings ***
Documentation       The __init__.robot file is executed before any test suite or group of test suites. It serves as a setup for the suites, ideal for environment, database, etc. configurations.

Library             DatabaseLibrary
Library             ${EXECDIR}/resources/libraries/DotEnv.py
Resource            ${EXECDIR}/resources/keywords/core/DataBase.keywords.resource

Suite Setup         Initialize Application Environment
Suite Teardown      Disconnect From Database

*** Keywords ***
Initialize Application Environment
    Set Environment Project Variables    pipeline=${PIPELINE}    environment=${ENVIRONMENT}
    Connect to application database
