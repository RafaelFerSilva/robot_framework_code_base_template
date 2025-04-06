*** Settings ***
Documentation     Data keywords module for test automation
...               
...               This module contains keywords related to creating and manipulating test data.
...               It provides functionality for:
...               - Generating Brazilian phone numbers (mobile and landline)
...               - Formatting and manipulating dates
...               - Formatting Brazilian documents (CPF/CNPJ)
...               - Generating random data
...               - Formatting values according to Brazilian standards

Library        DateTime
Library        FakerLibrary     locale=pt_BR
Library        JSONLibrary
Resource       ./Common.keywords.resource

*** Variables ***
&{MESES}=           1=Janeiro
...                 2=Fevereiro
...                 3=Março
...                 4=Abril
...                 5=Maio
...                 6=Junho
...                 7=Julho
...                 8=Agosto
...                 9=Setembro
...                 10=Outubro
...                 11=Novembro
...                 12=Dezembro

*** Keywords ***

Return a DDD from Brazil
    [Documentation]    Returns a random Brazilian phone area code (DDD).
    ...                Reads a JSON file ddd_brasil.json and returns a random DDD.
    ...
    ...    Returns:
    ...    - A random Brazilian area code (DDD)
    ...
    ...    Example:
    ...    |    ${ddd}=    |    Return a DDD from Brazil    |            |
    ...    |    Log        |    ${ddd}                      |    19      |
    ${file}=    Return the file path from the files folder    json    ddd_brasil.json
    ${json_object}=         Load JSON From File        ${file}
    ${keys}=                Call Method                ${json_object['estadoPorDdd']}    keys
    ${ddd_list}=            Convert To List            ${keys}
    ${max}=                 Get Length                 ${ddd_list}
    ${random_ddd_index}=    FakerLibrary.Random Int    min=0                             max=${max - 1}
    ${ddd}=	Get From List    ${ddd_list}	${random_ddd_index}
    RETURN    ${ddd}

Return a Brazilian cell phone number
    [Documentation]    Generates a random Brazilian cell phone number.
    ...
    ...    Returns:
    ...    - A formatted Brazilian cell phone number
    ...
    ...    Example:
    ...    |    ${cell}    |    Return a Brazilian cell phone number    |                        |
    ...    |    Log        |    ${cell}                                 |    (64) 99595-3867     | 
    ${DDD}=               Return a DDD from Brazil
    ${TELEFONE_START}=    FakerLibrary.Random Number    digits=3    fix_len=3
    ${TELEFONE_FINAL}=    FakerLibrary.Random Number    digits=4    fix_len=4
    RETURN    (${DDD}) 99${TELEFONE_START}-${TELEFONE_FINAL}

Return cell phone formatted with () and - for cell phone with 11 characters
    [Documentation]    Formats a number into Brazilian cell phone standard format.
    ...
    ...    Arguments:
    ...    - celular: Cell phone number (11 digits)
    ...
    ...    Returns:
    ...    - Formatted cell phone number
    ...
    ...    Example:
    ...    |    ${mobile}=    |    Return cell phone formatted with () and - for cell phone with 11 characters    |    19999985654    |
    ...    Returns:
    ...    |    (19) 99998-5654
    [Arguments]    ${celular}

    ${fone_final}=    Get Substring    ${celular}    -4
    ${fone_start}=    Get Substring    ${celular}    0    2
    ${fone_meio}=     Get Substring    ${celular}    2    7
    ${mobile}=     Catenate    (${fone_start})     ${fone_meio}-${fone_final}
    
    RETURN    ${mobile}

Return a Brazilian landline number
    [Documentation]    Generates a random Brazilian landline phone number.
    ...
    ...    Returns:
    ...    - A formatted Brazilian landline number
    ...
    ...    Example:
    ...    |    ${phone}   |    Return a Brazilian landline number    |                        |
    ...    |    Log        |    ${phone}                              |    (22) 3981-3969      | 
    ${DDD}=               Return a DDD from Brazil
    ${TELEFONE_START}=    FakerLibrary.Random Number    digits=3    fix_len=3
    ${TELEFONE_FINAL}=    FakerLibrary.Random Number    digits=4    fix_len=4
    RETURN    (${DDD}) 3${TELEFONE_START}-${TELEFONE_FINAL}

Return a date with pt-BR format
    [Documentation]    Generates a date in Brazilian format (day-month-year) with a minimum/maximum age range.
    ...
    ...    Arguments:
    ...    - min: Minimum age (default: 18)
    ...    - max: Maximum age (default: 100)
    ...
    ...    Returns:
    ...    - Date in DD-MM-YYYY format
    ...
    ...    Example:
    ...    |    ${date}    |    Return a date with pt-BR format    |                        |
    ...    |    Log        |    ${date}                            |    26-03-1961          |
    [Arguments]        ${min}=18         ${max}=100
    ${date}=    FakerLibrary.Date_Of_Birth                minimum_age=${min}    maximum_age=${max}
    ${format_date}=    Format a date for the pt-BR system    ${date}
    RETURN    ${format_date}

Add or Decrease years to current date
    [Documentation]    Adds or subtracts years from the current date.
    ...    Takes the current year and performs the calculation using the provided arithmetic operator.
    ...
    ...    Arguments:
    ...    - anos_a_alterar: Number of years to add or subtract
    ...    - operador_aritmetico: Arithmetic operator to use (+ or -)
    ...
    ...    Returns:
    ...    - Modified date in DD/MM/YYYY format
    [Arguments]     ${anos_a_alterar}   ${operador_aritmetico}   

    ${data} =	Get Current Date	result_format=datetime
    ${month}=   Set Variable If    ${data.month} < 10        0${data.month}    ${data.month}
    ${day}=     Set Variable If    ${data.day} < 10        0${data.day}    ${data.day}

    RETURN    ${day}/${month}/${data.year ${operador_aritmetico} ${anos_a_alterar}}

Return current date
    [Documentation]    Returns the current date in DD/MM/YYYY format.
    ...    Also sets a test variable ${DATA_ACTUAL} with the current date.
    ...
    ...    Returns:
    ...    - Current date in DD/MM/YYYY format
    ${data} =	Get Current Date	result_format=datetime
    ${month}=    Set Variable If    ${data.month} < 10        0${data.month}    ${data.month}
    ${day}=    Set Variable If    ${data.day} < 10        0${data.day}    ${data.day}
    Set Test Variable  $DATA_ATUAL     ${day}/${month}/${data.year}
   RETURN    ${day}/${month}/${data.year}

Increment a date
    [Documentation]    Adds a specified number of days to a date.
    ...    Works with dates in DD/MM/YYYY format.
    ...
    ...    Arguments:
    ...    - dataAtual: Current date in DD/MM/YYYY format
    ...    - quantidadeDias: Number of days to add
    ...
    ...    Returns:
    ...    - New date in DD/MM/YYYY format
    [Arguments]    ${dataAtual}    ${quantidadeDias}
    ${novaData}=             Add Time To Date    ${dataAtual}    ${quantidadeDias} days    date_format=%d/%m/%Y    result_format=%d/%m/%Y
   RETURN    ${novaData}

Add days to current date
    [Documentation]    Adds a specified number of days to the current date.
    ...
    ...    Arguments:
    ...    - quantidade_dias: Number of days to add
    ...
    ...    Returns:
    ...    - New date with all separators removed (DDMMYYYY format)
    [Arguments]         ${quantidade_dias}

    ${data_atual}=          Return current date    
    ${data_formatada}=      Increment a date  ${data_atual}  ${quantidade_dias}
    ${nova_data}=            Remove parentheses spaces dots slashes and hyphens from a string      ${data_formatada}
   RETURN    ${nova_data}

Format a CNPJ
    [Documentation]    Formats a CNPJ number with proper separators.
    ...
    ...    Arguments:
    ...    - cnpj: CNPJ number (14 digits)
    ...
    ...    Returns:
    ...    - Formatted CNPJ (XX.XXX.XXX/XXXX-XX)
    [Arguments]    ${cnpj}

    ${bloco_1}=        Get Substring    ${cnpj}    0    2
    ${bloco_2}=        Get Substring    ${cnpj}    2    5
    ${bloco_3}=        Get Substring    ${cnpj}    5    8
    ${bloco_4}=        Get Substring    ${cnpj}    8    12
    ${bloco_5}=        Get Substring    ${cnpj}    12   14

    RETURN    ${bloco_1}.${bloco_2}.${bloco_3}/${bloco_4}-${bloco_5}

Format a CPF
    [Documentation]    Formats a CPF number with proper separators.
    ...
    ...    Arguments:
    ...    - cpf: CPF number (11 digits)
    ...
    ...    Returns:
    ...    - Formatted CPF (XXX.XXX.XXX-XX)
    [Arguments]    ${cpf}

    ${bloco_1}=        Get Substring    ${cpf}    0    3
    ${bloco_2}=        Get Substring    ${cpf}    3    6
    ${bloco_3}=        Get Substring    ${cpf}    6    9
    ${bloco_4}=        Get Substring    ${cpf}    9    11

    RETURN    ${bloco_1}.${bloco_2}.${bloco_3}-${bloco_4}

Format CPF/CNPJ document
    [Documentation]    Automatically formats a document number as CPF or CNPJ based on its length.
    ...
    ...    Arguments:
    ...    - documento: Document number (CPF or CNPJ)
    ...
    ...    Returns:
    ...    - Formatted document (CPF or CNPJ)
    [Arguments]    ${documento}

    ${doc}=    Set Variable    ${documento}

    ${length}=  Get Length	 ${doc}
    IF    ${length} == 11
        ${doc}=    Format a CPF    ${documento}
    ELSE
        ${doc}=   Format a CNPJ    ${documento}
    END

    RETURN     ${doc}

Return the month by number
    [Documentation]    Returns the month name in Portuguese based on its number.
    ...
    ...    Arguments:
    ...    - num_mes: Month number (1-12)
    ...
    ...    Returns:
    ...    - Month name in Portuguese
    [Arguments]    ${num_mes}
    ${string_num}=    Convert To String    ${num_mes}   
    RETURN   ${MESES}[${string_num}]

Return a random group of letters
    [Documentation]    Generates a random string of letters with the specified length.
    ...
    ...    Arguments:
    ...    - number: Number of characters to generate
    ...
    ...    Returns:
    ...    - Random string of letters
    [Arguments]    ${number}
    ${grupo}=   Set Variable    ${EMPTY}
    FOR  ${num}  IN RANGE  ${number}
        ${letra}=    FakerLibrary.Random Letter
        ${grupo}=    Catenate    SEPARATOR=     ${grupo}    ${letra}
    END
    RETURN    ${grupo}

Format value to Brazilian decimal
    [Documentation]    Formats a numeric value to Brazilian decimal format (using comma as decimal separator).
    ...
    ...    Arguments:
    ...    - valor: Numeric value to format
    ...
    ...    Returns:
    ...    - Value formatted in Brazilian decimal format (X.XXX,XX)
    [Arguments]    ${valor}
    # Store the original value for logging
    Log   Valor original recebido: ${valor}
    
    # Explicitly convert to string
    ${valor_str} =    Convert To String    ${valor}
    
    # If it's a Decimal object as string, extract the numeric value
    ${decimal_match} =    Run Keyword And Return Status    Should Match Regexp    ${valor_str}    .*Decimal\\('.*'\\).*
    IF    ${decimal_match}
        ${valor_str} =    Evaluate    ''.join([c for c in "${valor_str}" if c.isdigit() or c == '.' or c == ','])
    END
    
    # Check current format
    ${tem_virgula} =    Run Keyword And Return Status    Should Contain    ${valor_str}    ,
    
    # Convert to float
    IF    ${tem_virgula}
        # Brazilian format (1.234,56) -> numeric format (1234.56)
        ${valor_num_str} =    Replace String    ${valor_str}    .    ${EMPTY}
        ${valor_num_str} =    Replace String    ${valor_num_str}    ,    .
    ELSE
        # Already in numeric or American format
        ${valor_num_str} =    Set Variable    ${valor_str}
    END
    
    # Try to convert to number
    TRY
        ${valor_num} =    Convert To Number    ${valor_num_str}
        
        # Format in Brazilian standard
        ${valor_formatado} =    Evaluate    "{:,.2f}".format(${valor_num}).replace(",", "X").replace(".", ",").replace("X", ".")
    EXCEPT
        # In case of error, return the original value
        ${valor_formatado} =    Set Variable    ${valor_str}
        Log   Erro ao converter para número. Usando valor original.
    END
    
    Log   Valor formatado: ${valor_formatado}
    RETURN    ${valor_formatado}
