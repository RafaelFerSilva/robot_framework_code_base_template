*** Settings ***
Documentation     String Manipulation module for the test automation framework
...               
...               This module deals with string formatting, cleaning, and regex operations.
...               It provides functionality for:
...               - Replacing string templates with scalar or dictionary variables
...               - Date formatting for pt-BR systems
...               - Scrubbing strings (removing dots, commas, parentheses, etc)

Library           String


*** Keywords ***
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
