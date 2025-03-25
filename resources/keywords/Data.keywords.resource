*** Settings ***
Documentation    keywords related to creating data for tests

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
    [Documentation]    Return a Brazilian Phone DDD.
    ...                Read a Json file ddd_brasil.json and return a randon DDD.
    ...
    ...    = Examples =
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
    [Documentation]    Return a Brazilian cell phone number
    ...
    ...     = Examples =
    ...     |    ${cell}    |    Return a Brazilian cell phone number    |                        |
    ...     |    Log        |    ${cell}                                 |    (64) 99595-3867     | 
    ${DDD}=               Return a DDD from Brazil
    ${TELEFONE_START}=    FakerLibrary.Random Number    digits=3    fix_len=3
    ${TELEFONE_FINAL}=    FakerLibrary.Random Number    digits=4    fix_len=4
    RETURN    (${DDD}) 99${TELEFONE_START}-${TELEFONE_FINAL}

Return cell phone formatted with () and - for cell phone with 11 characters
    [Documentation]    Receive a number and return the same in Brazilian cell phone standart
    ...
    ...    = Examples =
    ...    |    ${mobile}=    |    Return cell phone formatted with () and - for cell phone with 11 characters    |    19999985654    |
    ...    = Return =
    ...    | ${module}    |    (19) 99998-5654
    [Arguments]    ${celular}

    ${fone_final}=    Get Substring    ${celular}    -4
    ${fone_start}=    Get Substring    ${celular}    0    2
    ${fone_meio}=     Get Substring    ${celular}    2    7
    ${mobile}=     Catenate    (${fone_start})     ${fone_meio}-${fone_final}
    
    RETURN    ${mobile}

Return a Brazilian landline number
    [Documentation]    Return a Brazilian landline number.
    ...
    ...     = Examples =
    ...     |    ${phone}   |    Return a Brazilian landline number    |                        |
    ...     |    Log        |    ${phone}                              |    (22) 3981-3969      | 
    ${DDD}=               Return a DDD from Brazil
    ${TELEFONE_START}=    FakerLibrary.Random Number    digits=3    fix_len=3
    ${TELEFONE_FINAL}=    FakerLibrary.Random Number    digits=4    fix_len=4
    RETURN    (${DDD}) 3${TELEFONE_START}-${TELEFONE_FINAL}

Return a date with pt-BR format
    [Documentation]    Returns a date of birth in Brazilian format, day-month-year and with a minimum/maximum period related to age. Default 18 years
    ...
    ...     = Examples =
    ...     |    ${date}    |    Return a date with pt-BR format    |                        |
    ...     |    Log        |    ${date}                            |    26-03-1961          |
    [Arguments]        ${min}=18         ${max}=100
    ${date}=    FakerLibrary.Date_Of_Birth                minimum_age=${min}    maximum_age=${max}
    ${format_date}=    Format a date for the pt-BR system    ${date}
    RETURN    ${format_date}

Add or Decrease years to current date
    [Documentation]     We return the date to the current date and add or subtract a value in years. The value changes directly in the year of the date.
    ...         We take the year and perform the calculation using the arithmetic operator passed as a file
    [Arguments]     ${anos_a_alterar}   ${operador_aritmetico}   

    ${data} =	Get Current Date	result_format=datetime
    ${month}=   Set Variable If    ${data.month} < 10        0${data.month}    ${data.month}
    ${day}=     Set Variable If    ${data.day} < 10        0${data.day}    ${data.day}

    RETURN    ${day}/${month}/${data.year ${operador_aritmetico} ${anos_a_alterar}}

Return current date
    [Documentation]     Returns the current date and can be used as a test variable ${DATA_ACTUAL} set as return by the keyword
    ${data} =	Get Current Date	result_format=datetime
    ${month}=    Set Variable If    ${data.month} < 10        0${data.month}    ${data.month}
    ${day}=    Set Variable If    ${data.day} < 10        0${data.day}    ${data.day}
    Set Test Variable  $DATA_ATUAL     ${day}/${month}/${data.year}
   RETURN    ${day}/${month}/${data.year}

Increment a date
    [Documentation]    The method works in the receive and return format for "%d/%m/%Y", example: 03/07/1998.
    [Arguments]    ${dataAtual}    ${quantidadeDias}
    ${novaData}=             Add Time To Date    ${dataAtual}    ${quantidadeDias} days    date_format=%d/%m/%Y    result_format=%d/%m/%Y
   RETURN    ${novaData}

Add days to current date
    [Documentation]    The method receives the current date and adds the days defined in the argument
    [Arguments]         ${quantidade_dias}

    ${data_atual}=          Return current date    
    ${data_formatada}=      Increment a date  ${data_atual}  ${quantidade_dias}
    ${nova_data}=            Remove parentheses spaces dots slashes and hyphens from a string      ${data_formatada}
   RETURN    ${nova_data}

Format a CNPJ
    [Arguments]    ${cnpj}

    ${bloco_1}=        Get Substring    ${cnpj}    0    2
    ${bloco_2}=        Get Substring    ${cnpj}    2    5
    ${bloco_3}=        Get Substring    ${cnpj}    5    8
    ${bloco_4}=        Get Substring    ${cnpj}    8    12
    ${bloco_5}=        Get Substring    ${cnpj}    12   14

    RETURN    ${bloco_1}.${bloco_2}.${bloco_3}/${bloco_4}-${bloco_5}

Format a CPF
    [Arguments]    ${cpf}

    ${bloco_1}=        Get Substring    ${cpf}    0    3
    ${bloco_2}=        Get Substring    ${cpf}    3    6
    ${bloco_3}=        Get Substring    ${cpf}    6    9
    ${bloco_4}=        Get Substring    ${cpf}    9    11

    RETURN    ${bloco_1}.${bloco_2}.${bloco_3}-${bloco_4}

Format CPF/CNPJ document
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
    [Arguments]    ${num_mes}
    ${string_num}=    Convert To String    ${num_mes}   
    RETURN   ${MESES}[${string_num}]

Return a random group of letters
    [Documentation]    The argument ${number} is the number of characters we want in the string
    [Arguments]    ${number}
    ${grupo}=   Set Variable    ${EMPTY}
    FOR  ${num}  IN RANGE  ${number}
        ${letra}=    FakerLibrary.Random Letter
        ${grupo}=    Catenate    SEPARATOR=     ${grupo}    ${letra}
    END
    RETURN    ${grupo}

Format value to Brazilian decimal
    [Arguments]    ${valor}
    # Armazenar o valor original para log
    Log   Valor original recebido: ${valor}
    
    # Converter explicitamente para string
    ${valor_str} =    Convert To String    ${valor}
    
    # Se for um objeto Decimal como string, extrair o valor numérico
    ${decimal_match} =    Run Keyword And Return Status    Should Match Regexp    ${valor_str}    .*Decimal\\('.*'\\).*
    IF    ${decimal_match}
        ${valor_str} =    Evaluate    ''.join([c for c in "${valor_str}" if c.isdigit() or c == '.' or c == ','])
    END
    
    # Verificar formato atual
    ${tem_virgula} =    Run Keyword And Return Status    Should Contain    ${valor_str}    ,
    
    # Converter para float
    IF    ${tem_virgula}
        # Formato brasileiro (1.234,56) -> formato numérico (1234.56)
        ${valor_num_str} =    Replace String    ${valor_str}    .    ${EMPTY}
        ${valor_num_str} =    Replace String    ${valor_num_str}    ,    .
    ELSE
        # Já está em formato numérico ou americano
        ${valor_num_str} =    Set Variable    ${valor_str}
    END
    
    # Tentar converter para número
    TRY
        ${valor_num} =    Convert To Number    ${valor_num_str}
        
        # Formatar no padrão brasileiro
        ${valor_formatado} =    Evaluate    "{:,.2f}".format(${valor_num}).replace(",", "X").replace(".", ",").replace("X", ".")
    EXCEPT
        # Em caso de erro, retornar o valor original
        ${valor_formatado} =    Set Variable    ${valor_str}
        Log   Erro ao converter para número. Usando valor original.
    END
    
    Log   Valor formatado: ${valor_formatado}
    RETURN    ${valor_formatado}
