*** Settings ***
Resource        ${EXECDIR}/resources/keywords/core/Data.keywords.resource

Test Tags       data


*** Test Cases ***
Should be possible Return A DDD From Brazil
    ${ddd}=    Return A DDD From Brazil
    Log    ${ddd}

Should be possible Return A Brazilian Cell Phone Number
    ${cell}=    Return A Brazilian Cell Phone Number
    Log    ${cell}

Should be possible Return a Brazilian landline number
    ${phone}=    Return a Brazilian landline number
    Log    ${phone}

Should be possible Return a date with pt-BR format
    ${date}=    Return a date with pt-BR format
    Log    ${date}
