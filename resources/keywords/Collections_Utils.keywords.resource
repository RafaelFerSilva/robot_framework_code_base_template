*** Settings ***
Documentation     Collections handling module for the test automation framework
...               
...               This module provides advanced iterations and filtering over dictionaries and lists.

Library           Collections
Library           ${EXECDIR}/resources/libraries/CollectionsHelper.py


*** Keywords ***
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
    ...    - List of consolidated objects containing a new key "Quantidade"
    [Arguments]    ${lista_objetos}    ${key}=Nome

    ${response}=    Consolidate Objects By Key    ${lista_objetos}    ${key}
    RETURN    ${response}
