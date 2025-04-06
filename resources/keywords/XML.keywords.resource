Here's the corrected XML.keywords.resource file with documentation in English:

*** Settings ***
Documentation     XML keywords module for test automation
...               
...               This module contains keywords for working with XML files.
...               It provides functionality for:
...               - Extracting information from XML files
...               - Parsing XML content
...               - Retrieving specific XML elements and attributes
...               
...               Dependencies:
...               - XML library

Library             OperatingSystem
Library             XML


*** Keywords ***

Return XML File Element Text
    [Documentation]    Extracts the text content of a specific element from an XML file.
    ...
    ...    Arguments:
    ...    - xml_file_name: Name of the XML file to process
    ...    - element_path: XPath to the element whose text should be extracted
    ...
    ...    Returns:
    ...    - The text content of the specified element
    ...
    ...    Behavior:
    ...    - Reads the XML file from the resources/files/xml directory
    ...    - Parses the XML content
    ...    - Locates the element using the provided path
    ...    - Returns the text content of the element
    [Arguments]    ${xml_file_name}    ${element_path}

    ${FILE_CONTENT}=    Get File    ${EXECDIR}/resources/files/xml/${xml_file_name}
    ${root}=    Parse XML    ${FILE_CONTENT}
    ${element}=    XML.Get Element    ${root}    ${element_path}
    ${text}=    Get Element Text    ${element}

    RETURN    ${text}
