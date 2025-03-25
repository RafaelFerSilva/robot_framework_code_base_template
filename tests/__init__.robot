*** Settings ***
Library         DatabaseLibrary
Library         ${EXECDIR}/resources/libraries/DotEnv.py
Variables       ${EXECDIR}/resources/config_variables.py

Suite Setup     Set Environment Project Variables    pipeline=${PIPELINE}    environment=${ENVIRONMENT}    print_variables=True
