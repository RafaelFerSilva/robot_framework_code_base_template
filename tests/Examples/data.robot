*** Settings ***
Resource        ${EXECDIR}/resources/keywords/Data.keywords.resource

Test Tags       data


*** Test Cases ***
Should be possible Return a DDD from Brazil
    ${ddd}=    Return a DDD from Brazil
    Log    ${ddd}

Should be possible Return a Brazilian cell phone number
    ${cell}=    Return a Brazilian cell phone number
    Log    ${cell}

Should be possible Return a Brazilian landline number
    ${phone}=    Return a Brazilian landline number
    Log    ${phone}

Should be possible Return a date with pt-BR format
    ${date}=    Return a date with pt-BR format
    Log    ${date}
