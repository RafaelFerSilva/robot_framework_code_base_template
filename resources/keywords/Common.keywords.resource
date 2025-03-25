*** Settings ***
Documentation       This module is responsible to our common framework keywords

Library             Browser
Library             FakerLibrary
Library             String
Library             Collections
Library             OperatingSystem
Library             JSONLibrary
Library             RequestsLibrary
Variables           ${EXECDIR}/resources/config_variables.py


*** Variables ***
${RESOURCES}            ${EXECDIR}/resources
${RESOURCES_FILES}      ${RESOURCES}/files
${SQL_FOLDER}           ${RESOURCES}/sql/


*** Keywords ***
Set language
    [Documentation]    This keyword read a string language Dictionaries inside folder resorces/files/i18n.
    ...
    ...    Exemple files:
    ...    | pt.json
    ...    | ar.json
    ...
    ...
    ...    = Examples =
    ...    |    Set language    PT
    ...
    [Arguments]    ${set_language}=${LANG}

    ${FILE}=    Load Json From File    ${RESOURCES_FILES}/i18n/${LANGUAGE_DIC}[${set_language}].json    utf-8
    ${LANGUAGE}=    Convert To Dictionary    ${FILE['${LANGUAGE_DIC}[${set_language}]']}
    Set Global Variable    ${LANGUAGE}    ${LANGUAGE}

Define test data by language
    [Documentation]    Keyword with the objective of identifying *Language* and *URL* on which the tests will be executed.
    ...    This keyword should preferably be used before executing the test suites
    ...
    ...    = Examples =
    ...    | Define test data by language |    PT    |
    [Arguments]    ${set_language}=${LANG}    ${env}=${ENVIRONMENT}

    VAR    ${URL}    ${URLS}[${env}]
    Set Global Variable    ${URL}    ${URLS}[${env}]
    Set language    ${set_language}

Set Mobile device to context
    ${device}=    Get Device    ${DEVICE_NAME}
    ${copy_new_context}=    Copy Dictionary    ${NEW_CONTEXT}    deepcopy=TRUE
    Set To Dictionary    ${copy_new_context}    &{device}
    New Context    &{copy_new_context}

Config New Context
    IF    ${MOBILE}
        Set Mobile device to context
    ELSE
        New Context    &{NEW_CONTEXT}
    END

Receive a list of cookies and add to context
    [Arguments]    ${cookies}=[]

    IF    ${cookies}!=None
        IF    ${cookies}!=[]
            FOR    ${cookie}    IN    @{cookies}
                Add Cookie    &{cookie}
            END
        END
    END

Open the browser with config
    [Documentation]    Use NEW_CONTEXT object (config_variables.py) to config Context
    [Arguments]    ${MOBILE}=${False}    ${COOKIES}=${None}    ${LOG_CONFIG}=${False}

    ${old_timeout}=    Set Browser Timeout    ${BROWSER_TIMEOUT} seconds

    Set Suite Variable    ${MOBILE}    ${MOBILE}

    New Browser    browser=${BROWSER}    headless=${HEADLESS}
    Config New Context
    Receive a list of cookies and add to context    ${COOKIES}
    New Page    ${URL}

    Set Browser Timeout    ${old_timeout}

    IF    ${LOG_CONFIG}
        Log To Console    \nSelected language: ${LANG}
        Log To Console    \nSelected language dictionary: ${RESOURCES_FILES}/i18n/${LANGUAGE_DIC}[${LANG}].json
        Log To Console    \nSelected ENVIRONMENT: ${ENVIRONMENT}
        Log To Console    \nSelected URL: ${URL}
        Log To Console    \nMobile: ${MOBILE}
    END

String Replace
    [Documentation]    Replaces the ocurrences of '$$' for the respective strings.
    ...
    ...    = Examples =
    ...    | ${element}=    |    String Replace    |    ${template}    |    @{replace_strings} |
    ...
    ...    The *template* argument is a string that contains the $$ that we want to change to another string.
    ...    The *replacement_strings* argument can be a list of strings that will be placed in place of the $$ in the template
    [Arguments]    ${template}    @{replacement_strings}
    FOR    ${string}    IN    @{replacement_strings}
        ${string}=    Convert To String    ${string}
        ${template}=    Replace String    ${template}    $$    ${string}    count=1
    END
    RETURN    ${template}

String Replace Using Dictionary
    [Documentation]    Replaced the occurrences of the dictionary keys with the respective dictionary values.
    ...
    ...    = Examples =
    ...    Create a dictionary where the key value is the same as the item to be replaced in the template and the value corresponding to the key will be the value used in the replacement.
    ...
    ...    |    ${DICTIONARY}=    Create Dictionary    date=1953-06-03
    ...    |    ...    startDate=1999-07-23
    ...    |    ...    endDate=1993-09-17
    ...    Pass the string (template) that contains the values to be replaced and the dictionary contains the key and value for replacement
    ...    Template value:
    ...
    ...    ${template}=    {date} | Scheduled {startDate} a {endDate}
    ...
    ...    |    ${value}=    |    String Replace using dictionary    |    ${template}    |    ${DICTIONARY}    |
    ...    Return:
    ...    |    1953-06-03 | Scheduled for 1999-07-23 to 1993-09-17    |
    [Arguments]    ${template}    ${replacement_values}

    FOR    ${key_value}    IN    &{replacement_values}
        ${value}=    Convert To String    ${key_value}[1]
        ${template}=    Replace String    ${template}    {${key_value}[0]}    ${value}    count=1
    END

    RETURN    ${template}

Justified wait
    [Documentation]    Using sleep in tests is not a good option, but there are situations where it is necessary.
    ...    In cases where we have no other way of waiting, we must use sleep but justifying its reason.
    ...
    ...    = Examples =
    ...    |    Justified wait    |    3s    |    Wait for database returns    |
    ...
    ...    Return:
    ...    |    Reason for using sleep: Wait for database returns
    [Arguments]    ${wait}    ${message}
    Log    Reason for using sleep: ${message}
    Sleep    ${wait}

Return the file path from the files folder
    [Documentation]    Return a path of file to be used in tests.
    ...    This keyword does not validate whether the file exists, the keyword only creates a path based on the path of the framework's file folder
    ...
    ...    = Examples =
    ...    |    ${file_path}=    |    Return the file path from the files folder    |    i18n    |    language_pt.json    |
    [Arguments]    ${folder}    ${file}
    ${file}=    String Replace    ${RESOURCES_FILES}/$$/$$    ${folder}    ${file}
    RETURN    ${file}

Return the contents of a file for testing - utf-8
    [Documentation]    Return a content of file inside resource files folder.
    ...
    ...    = Examples =
    ...    |    ${content}=    |    Return the contents of a file for testing - utf-8    |    i18n    |    language_pt.json    |
    [Arguments]    ${folder}    ${file_name}
    ${file_path}=    Return the file path from the files folder    ${folder}    ${file_name}
    ${file}=    Get File    ${file_path}    encoding='utf-8-sig'    encoding_errors=strict
    RETURN    ${file}

Format a date for the pt-BR system
    [Documentation]    Format a date that is 1945-07-30 00:00:00 for only the date in the pt-BR system 30-07-1945
    ...    = Examples =
    ...    |    ${date}=    |    Format a date for the pt-BR system    |    1945-07-30 00:00:00    |
    ...    |    ${date}    |    30-07-1945    |    |
    [Arguments]    ${data}
    ${month}=    Set Variable If    ${data.month} < 10    0${data.month}    ${data.month}
    ${day}=    Set Variable If    ${data.day} < 10    0${data.day}    ${data.day}
    RETURN    ${day}-${month}-${data.year}

Split a string and return the number of items
    [Documentation]    Receive a string an use a separator for split content
    ...
    ...    = Examples =
    ...    |    ${value}=    |    Split a string and return the number of items    |    teste-teste    |    separator=-    |
    ...    |    Should Be Equal As Integers    |    ${value}    |    2    |    |
    [Arguments]    ${string_for_split}    ${separator}

    ${value_string}=    Convert To String    ${string_for_split}
    ${response_list}=    Split String    ${value_string}    ${separator}
    ${quantity_of_items}=    Get Length    ${response_list}

    RETURN    ${quantity_of_items}

Remove parentheses spaces dots slashes and hyphens from a string
    [Documentation]    Remove caracteres from string.
    ...
    ...    = Examples =
    ...
    ...    |    ${value}=    |    Remove parentheses spaces dots slashes and hyphens from a string    |    teste -teste// \\teste..    |
    ...    |    Should Be Equal As Strings    |    ${value}    |    testeteste\\teste    |
    [Arguments]    ${text}

    ${return_text}=    Remove String    ${text}    (    )    -    .    /    \    ${SPACE}

    RETURN    ${return_text}

Remove dots from a string
    [Documentation]    Remove dots from string
    ...
    ...    = Examples =
    ...    |    ${value}=    |    Remove dots from a string    |    tes.te...teste    |
    ...    |    Should Be Equal As Strings    |    ${value}    |    testeteste    |
    [Arguments]    ${text}
    ${text}=    Convert To String    ${text}
    ${return_text}=    Remove String    ${text}    .
    RETURN    ${return_text}

Remove comma from a string
    [Documentation]    Remove comma from a string
    ...
    ...    = Exemple =
    ...    |    ${value}=    |    Remove comma from a string    |    test,te,stes    |
    ...    |    Should Be Equal As Strings    |    ${value}    |    testtestes    |
    [Arguments]    ${text}
    ${return_text}=    Remove String    ${text}    ,
    RETURN    ${return_text}

Get Dictionary list data by key and value
    [Documentation]    Returns a list of all items in a dictionary that have the value of a specified key.
    [Arguments]    ${data}    ${key}    ${value}

    ${filtered_items}=    Create List
    FOR    ${item}    IN    @{data}
        IF    '${item["${key}"]}' == '${value}'
            Append To List    ${filtered_items}    ${item}
        END
    END
    RETURN    ${filtered_items}

Removes objects with the same key and returns a list with unique objects and their quantity
    [Documentation]    Consolidates objects by key, keeping only one of each and adding the count
    [Arguments]    ${lista_objetos}    ${key}=Nome
    ${count_keys}=    Create Dictionary
    ${object_by_key}=    Create Dictionary

    # Primeiro, conta as ocorrências de cada ${key} e guarda o primeiro objeto de cada ${key}
    FOR    ${objeto}    IN    @{lista_objetos}
        ${value_key}=    Get From Dictionary    ${objeto}    ${key}

        # Conta as ocorrências deste ${key}
        ${value_key_existe}=    Run Keyword And Return Status
        ...    Dictionary Should Contain Key
        ...    ${count_keys}
        ...    ${value_key}
        IF    ${value_key_existe}
            ${count}=    Get From Dictionary    ${count_keys}    ${value_key}
            ${new_count}=    Evaluate    ${count} + 1
            Set To Dictionary    ${count_keys}    ${value_key}=${new_count}
        ELSE
            Set To Dictionary    ${count_keys}    ${value_key}=1
            # Guarda o primeiro objeto com este ${key}
            Set To Dictionary    ${object_by_key}    ${value_key}=${objeto}
        END
    END

    # Depois, cria a lista de resultado com os objetos únicos e suas contagens
    ${resultado}=    Create List
    ${value_keys}=    Get Dictionary Keys    ${count_keys}

    FOR    ${value_key}    IN    @{value_keys}
        ${count}=    Get From Dictionary    ${count_keys}    ${value_key}
        ${objeto}=    Get From Dictionary    ${object_by_key}    ${value_key}

        # Cria uma cópia do objeto para não modificar o original
        ${objeto_com_contagem}=    Copy Dictionary    ${objeto}

        # Adiciona a chave Quantidade
        Set To Dictionary    ${objeto_com_contagem}    Quantidade=${count}

        # Adiciona ao resultado
        Append To List    ${resultado}    ${objeto_com_contagem}
    END

    Log Many    ${resultado}

    RETURN    ${resultado}
