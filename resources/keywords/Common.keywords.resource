*** Settings ***
Documentation     Common keywords module for the test automation framework
...               
...               This module contains common framework keywords that can be reused across different test suites.
...               It provides functionality for:
...               - Test environment configuration (language, URL)
...               - Browser handling
...               - String manipulation
...               - File handling
...               - Date formatting
...               - Dictionary and list manipulation

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
    [Documentation]    Configures the language for tests by loading a JSON language dictionary file.
    ...
    ...    The file must be located in resources/files/i18n/ with the name in the format [language].json
    ...
    ...    Arguments:
    ...    - file_name: Language file name (default: value of global variable ${LANG})
    ...
    ...    Returns:
    ...    - Sets the global variable ${LANGUAGE} with the loaded language dictionary
    ...
    ...    Example:
    ...    |    Set language    PT
    [Arguments]    ${file_name}=${LANG}

    ${FILE}=    Load Json From File    ${RESOURCES_FILES}/i18n/${file_name}.json    utf-8
    ${LANGUAGE_DIC}=    Convert To Dictionary    ${FILE}
    Set Global Variable    ${LANGUAGE}    ${LANGUAGE_DIC}

Set test URL
    [Documentation]    Sets the test URL based on the specified environment.
    ...
    ...    Arguments:
    ...    - env: Test environment (default: value of global variable ${ENVIRONMENT})
    ...
    ...    Returns:
    ...    - Sets the global variable ${URL} with the URL corresponding to the environment
    [Arguments]   ${env}=${ENVIRONMENT}

    VAR    ${URL}    ${URLS}[${env}]
    Set Global Variable    ${URL}    ${URLS}[${env}]

Define test data
    [Documentation]    Configures test data by identifying language and URL for test execution.
    ...    This keyword should preferably be used before executing the test suites.
    ...
    ...    Arguments:
    ...    - set_language_file_name: Language file name (default: value of global variable ${LANG})
    ...    - env: Test environment (default: value of global variable ${ENVIRONMENT})
    ...
    ...    Example:
    ...    | Define test data |    PT    |
    [Arguments]    ${set_language_file_name}=${LANG}    ${env}=${ENVIRONMENT}

    Set test URL    ${env}
    Set language    ${set_language_file_name}

Set Mobile device to context
    [Documentation]    Configures the browser context for a specific mobile device.
    ...
    ...    Uses the global variable ${DEVICE_NAME} to get the device settings
    ...    and applies these settings to the browser context.
    ${device}=    Get Device    ${DEVICE_NAME}
    ${copy_new_context}=    Copy Dictionary    ${NEW_CONTEXT}    deepcopy=TRUE
    Set To Dictionary    ${copy_new_context}    &{device}
    New Context    &{copy_new_context}

Config New Context
    [Documentation]    Configures a new browser context based on the mobile device flag.
    ...
    ...    If ${MOBILE} is true, configures a context for mobile device.
    ...    Otherwise, configures a default context using ${NEW_CONTEXT}.
    IF    ${MOBILE}
        Set Mobile device to context
    ELSE
        New Context    &{NEW_CONTEXT}
    END

Receive a list of cookies and add to context
    [Documentation]    Adds a list of cookies to the current browser context.
    ...
    ...    Arguments:
    ...    - cookies: List of cookies to add (default: empty list)
    [Arguments]    ${cookies}=[]

    IF    ${cookies}!=None
        IF    ${cookies}!=[]
            FOR    ${cookie}    IN    @{cookies}
                Add Cookie    &{cookie}
            END
        END
    END

Open the browser with config
    [Documentation]    Opens the browser with settings defined in the NEW_CONTEXT object (config_variables.py).
    ...
    ...    Arguments:
    ...    - MOBILE: Flag to indicate if mobile configuration should be used (default: ${False})
    ...    - COOKIES: List of cookies to add (default: ${None})
    ...    - LOG_CONFIG: Flag to indicate if configurations should be logged (default: ${False})
    ...
    ...    Behavior:
    ...    - Sets browser timeout
    ...    - Opens a new browser with defined settings
    ...    - Configures appropriate context (mobile or desktop)
    ...    - Adds cookies if provided
    ...    - Opens a new page with the defined URL
    ...    - Optionally logs the configurations used
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
    [Documentation]    Replaces occurrences of '$$' with corresponding strings.
    ...
    ...    Arguments:
    ...    - template: String containing the '$$' markers to be replaced
    ...    - replacement_strings: List of strings that will replace the '$$' markers
    ...
    ...    Returns:
    ...    - String with replaced markers
    ...
    ...    Example:
    ...    |    ${element}=    |    String Replace    |    ${template}    |    @{replace_strings} |
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
    [Documentation]    Replaces occurrences of dictionary keys with their respective values.
    ...
    ...    Arguments:
    ...    - template: String containing the {key} markers to be replaced
    ...    - replacement_values: Dictionary with keys and values for replacement
    ...
    ...    Returns:
    ...    - String with replaced markers
    ...
    ...    Example:
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
    [Documentation]    Uses sleep in tests when necessary, justifying its use.
    ...    Using sleep in tests is not a good practice, but there are situations where it is necessary.
    ...    In cases where we have no other way of waiting, we must use sleep but justify the reason.
    ...
    ...    Arguments:
    ...    - wait: Wait time
    ...    - message: Justification for using sleep
    ...
    ...    Example:
    ...    |    Justified wait    |    3s    |    Wait for database returns    |
    ...
    ...    Return:
    ...    |    Reason for using sleep: Wait for database returns
    [Arguments]    ${wait}    ${message}
    Log    Reason for using sleep: ${message}
    Sleep    ${wait}

Return the file path from the files folder
    [Documentation]    Returns a file path to be used in tests.
    ...    This keyword does not validate whether the file exists, it only creates a path based on the framework's file folder path.
    ...
    ...    Arguments:
    ...    - folder: Folder inside the files folder
    ...    - file: File name
    ...
    ...    Returns:
    ...    - Complete file path
    ...
    ...    Example:
    ...    |    ${file_path}=    |    Return the file path from the files folder    |    i18n    |    language_pt.json    |
    [Arguments]    ${folder}    ${file}
    ${file}=    String Replace    ${RESOURCES_FILES}/$$/$$    ${folder}    ${file}
    RETURN    ${file}

Return the contents of a file for testing - utf-8
    [Documentation]    Returns the content of a file inside the resource files folder.
    ...
    ...    Arguments:
    ...    - folder: Folder inside the files folder
    ...    - file_name: File name
    ...
    ...    Returns:
    ...    - File content
    ...
    ...    Example:
    ...    |    ${content}=    |    Return the contents of a file for testing - utf-8    |    i18n    |    language_pt.json    |
    [Arguments]    ${folder}    ${file_name}
    ${file_path}=    Return the file path from the files folder    ${folder}    ${file_name}
    ${file}=    Get File    ${file_path}    encoding='utf-8-sig'    encoding_errors=strict
    RETURN    ${file}

Format a date for the pt-BR system
    [Documentation]    Formats a date from 1945-07-30 00:00:00 to only the date in the pt-BR system format: 30-07-1945
    ...    
    ...    Arguments:
    ...    - data: Date object to format
    ...
    ...    Returns:
    ...    - Formatted date string in pt-BR format (DD-MM-YYYY)
    ...
    ...    Example:
    ...    |    ${date}=    |    Format a date for the pt-BR system    |    1945-07-30 00:00:00    |
    ...    |    ${date}    |    30-07-1945    |    |
    [Arguments]    ${data}
    ${month}=    Set Variable If    ${data.month} < 10    0${data.month}    ${data.month}
    ${day}=    Set Variable If    ${data.day} < 10    0${data.day}    ${data.day}
    RETURN    ${day}-${month}-${data.year}

Split a string and return the number of items
    [Documentation]    Receives a string and uses a separator to split content
    ...
    ...    Arguments:
    ...    - string_for_split: String to be split
    ...    - separator: Separator character
    ...
    ...    Returns:
    ...    - Number of items after splitting
    ...
    ...    Example:
    ...    |    ${value}=    |    Split a string and return the number of items    |    teste-teste    |    separator=-    |
    ...    |    Should Be Equal As Integers    |    ${value}    |    2    |    |
    [Arguments]    ${string_for_split}    ${separator}

    ${value_string}=    Convert To String    ${string_for_split}
    ${response_list}=    Split String    ${value_string}    ${separator}
    ${quantity_of_items}=    Get Length    ${response_list}

    RETURN    ${quantity_of_items}

Remove parentheses spaces dots slashes and hyphens from a string
    [Documentation]    Removes specific characters from a string.
    ...
    ...    Characters removed: parentheses, spaces, dots, slashes, and hyphens
    ...
    ...    Arguments:
    ...    - text: Text to be processed
    ...
    ...    Returns:
    ...    - String without the specified characters
    ...
    ...    Example:
    ...
    ...    |    ${value}=    |    Remove parentheses spaces dots slashes and hyphens from a string    |    teste -teste// \\teste..    |
    ...    |    Should Be Equal As Strings    |    ${value}    |    testeteste\\teste    |
    [Arguments]    ${text}

    ${return_text}=    Remove String    ${text}    (    )    -    .    /    \    ${SPACE}

    RETURN    ${return_text}

Remove dots from a string
    [Documentation]    Removes dots from a string
    ...
    ...    Arguments:
    ...    - text: Text to be processed
    ...
    ...    Returns:
    ...    - String without dots
    ...
    ...    Example:
    ...    |    ${value}=    |    Remove dots from a string    |    tes.te...teste    |
    ...    |    Should Be Equal As Strings    |    ${value}    |    testeteste    |
    [Arguments]    ${text}
    ${text}=    Convert To String    ${text}
    ${return_text}=    Remove String    ${text}    .
    RETURN    ${return_text}

Remove comma from a string
    [Documentation]    Removes commas from a string
    ...
    ...    Arguments:
    ...    - text: Text to be processed
    ...
    ...    Returns:
    ...    - String without commas
    ...
    ...    Example:
    ...    |    ${value}=    |    Remove comma from a string    |    test,te,stes    |
    ...    |    Should Be Equal As Strings    |    ${value}    |    testtestes    |
    [Arguments]    ${text}
    ${return_text}=    Remove String    ${text}    ,
    RETURN    ${return_text}

Get Dictionary list data by key and value
    [Documentation]    Returns a list of all items in a dictionary that have the value of a specified key.
    ...
    ...    Arguments:
    ...    - data: List of dictionaries to filter
    ...    - key: Key to filter by
    ...    - value: Key value to filter by
    ...
    ...    Returns:
    ...    - List of filtered dictionaries where key=value
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
    ...
    ...    Arguments:
    ...    - lista_objetos: List of dictionaries to process
    ...    - key: Key to group by (default: Nome)
    ...
    ...    Returns:
    ...    - List of unique dictionaries with occurrence count added in the 'Quantidade' key
    ...
    ...    Behavior:
    ...    - Counts occurrences of each value of the specified key
    ...    - Keeps only one object for each unique key value
    ...    - Adds the 'Quantidade' key with the number of occurrences
    [Arguments]    ${lista_objetos}    ${key}=Nome
    ${count_keys}=    Create Dictionary
    ${object_by_key}=    Create Dictionary

    # First, count occurrences of each ${key} and store the first object of each ${key}
    FOR    ${objeto}    IN    @{lista_objetos}
        ${value_key}=    Get From Dictionary    ${objeto}    ${key}

        # Count occurrences of this ${key}
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
            # Store the first object with this ${key}
            Set To Dictionary    ${object_by_key}    ${value_key}=${objeto}
        END
    END

    # Then, create the result list with unique objects and their counts
    ${resultado}=    Create List
    ${value_keys}=    Get Dictionary Keys    ${count_keys}

    FOR    ${value_key}    IN    @{value_keys}
        ${count}=    Get From Dictionary    ${count_keys}    ${value_key}
        ${objeto}=    Get From Dictionary    ${object_by_key}    ${value_key}

        # Create a copy of the object to avoid modifying the original
        ${objeto_com_contagem}=    Copy Dictionary    ${objeto}

        # Add the Quantidade key
        Set To Dictionary    ${objeto_com_contagem}    Quantidade=${count}

        # Add to result
        Append To List    ${resultado}    ${objeto_com_contagem}
    END

    Log Many    ${resultado}

    RETURN    ${resultado}
