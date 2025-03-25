*** Settings ***
Documentation       Keywords relateds a XML files

Resource            ./Common.keywords.resource
Library             XML


*** Keywords ***
Return XML infNFe id
    [Documentation]    This keyword accesses the content of an xml file and returns the id (barcode) of the infNFe element.
    [Arguments]    ${xml_file_name}

    ${xml}=    Return the file path from the files folder    xml    ${xml_file_name}
    ${FILE_CONTENT}=    Get File    ${xml}
    ${root}=    Parse XML    ${FILE_CONTENT}
    ${element}=    XML.Get Element    ${root}    NFe/infNFe
    ${id}=    Get Element Attribute    ${element}    Id
    ${barcode}=    Fetch From Right    ${id}    e

    RETURN    ${barcode}

Return XML File Element Text
    [Documentation]    This keyword accesses the content of an xml file and returns the element text by path.
    [Arguments]    ${xml_file_name}    ${element_path}

    ${FILE_CONTENT}=    Get File    ${EXECDIR}/resources/files/xml/${xml_file_name}
    ${root}=    Parse XML    ${FILE_CONTENT}
    ${element}=    XML.Get Element    ${root}    ${element_path}
    ${text}=    Get Element Text    ${element}

    RETURN    ${text}
