*** Settings ***
Documentation     Collections handling module for the test automation framework
...
...               This module provides advanced iterations and filtering over dictionaries and lists

Library           Collections
Library           ${EXECDIR}/resources/libraries/CollectionsHelper.py


*** Keywords ***
Get Dictionary List Data By Key And Value
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

