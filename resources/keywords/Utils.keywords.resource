*** Settings ***
Documentation     General Utilities module for the test automation framework
...               
...               This module contains generic actions like explicit justified waits.

Library           BuiltIn


*** Keywords ***
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
