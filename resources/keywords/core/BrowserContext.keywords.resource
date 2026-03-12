*** Settings ***
Documentation     Browser Management module for the test automation framework
...
...               This module manages the Browser Context, including:
...               - Desktop vs Mobile configurations
...               - Viewport, caching, and cookies context handling
...               - Opening browser instances using Playwright/Browser library

Library             Collections
Library             Browser

Variables           ${EXECDIR}/resources/config_variables.py


*** Variables ***
${RESOURCES}            ${EXECDIR}/resources
${RESOURCES_FILES}      ${RESOURCES}/files
${LANGUAGE_DIC}=        ${EMPTY}
${URL}=                 ${EMPTY}


*** Keywords ***
Set Mobile Device To Context
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
        Set Mobile Device To Context
    ELSE
        New Context    &{NEW_CONTEXT}
    END

Receive A List Of Cookies And Add To Context
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

Browser Log Info
    [Documentation]    Logs the current configuration of the browser context.
    [Arguments]    ${LOG_CONFIG}=${False}

    IF    ${LOG_CONFIG}
        Log To Console    \nSelected language: ${LANG}
        Log To Console    \nSelected language dictionary: ${RESOURCES_FILES}/i18n/${LANGUAGE_DIC}[${LANG}].json
        Log To Console    \nSelected ENVIRONMENT: ${ENVIRONMENT}
        Log To Console    \nSelected URL: ${URL}
        Log To Console    \nMobile: ${MOBILE}
    END

Open The Browser With Config
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
    Receive A List Of Cookies And Add To Context    ${COOKIES}
    New Page    ${URL}

    Set Browser Timeout    ${old_timeout}
    Browser Log Info    ${LOG_CONFIG}
