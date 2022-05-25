*** Settings ***
Library  OperatingSystem
Library  SeleniumLibrary
Library  DateTime
Library    String
Library    Process
Resource  Properties.txt
# *** Variables ***

# headlessChrome

*** Test Case ***
Buscar Arriendo
    Navegador
    Filtro
    Zona Norte
    Buscar
    Precios
#    Filtro
    Zona Sur
    Precios
    Buscar
#    Traer Lista
#    Login
#    Comercial
#    Pestaña SAS
#    Sales And Stock
#    Cerrar SAS y SSR
#    Pestaña SSR
#    Sales summary report
#    Cerrar SAS y SSR
#    close browser

*** Keywords ***
#Navegador
#    Open browser    ${pagina}  ${navegador}
Navegador
    ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
#    ${prefs}    Create Dictionary    download.default_directory=${ruta}
#    Call Method    ${chrome options}    add_experimental_option    prefs    ${prefs}
    Call Method    ${chrome_options}    add_argument    headless
    Call Method    ${chrome_options}    add_argument    disable-gpu
    Call Method    ${chrome_options}    add_argument    no-sandbox
    Create Webdriver    Chrome    chrome_options=${chrome_options}
    Set Window Size    1280    720
    Go To    ${pagina}

Click should be done
    [Arguments]    ${elem}
    Log To Console    Esperando para dar click
    Element Should Be Visible    ${elem}
    Click Element    ${elem}
Cambiar zona
    [Arguments]    ${name}    ${path}
    Log To Console    ${name}
#    Click Element    ${path}
    Wait Until Keyword Succeeds    1 min    1 sec    Click should be done    ${path}
    Sleep    1
    [Return]    ${name}
Filtro
#    Click element    xpath://*[@id="config_operationtype"]/option[3]
    Wait Until Keyword Succeeds    1 min    1 sec    Click should be done    xpath://*[@id="config_operationtype"]/option[3]
#    Sleep   1
#    Click element    xpath://*[@id="config_advicetype"]/option[3]
    Wait Until Keyword Succeeds    1 min    1 sec    Click should be done    xpath://*[@id="config_advicetype"]/option[3]
#    Sleep   1
#    Click element    xpath://*[@id="select_99"]/option[31]
    Wait Until Keyword Succeeds    1 min    1 sec    Click should be done    xpath://*[@id="select_99"]/option[31]
#    Sleep   1
#    Click Element    xpath://*[@id="select_100"]/option[11]
    Wait Until Keyword Succeeds    1 min    1 sec    Click should be done    xpath://*[@id="select_100"]/option[11]
#    Sleep   1

Zona Norte
    ${zona}=    Cambiar zona    NORTE    xpath://*[@id="select_145"]/option[3]
    Set Suite Variable    ${zona}
Zona Sur
    ${zona}=    Cambiar zona    SUR    xpath://*[@id="select_145"]/option[6]
    Set Suite Variable    ${zona}
Precios
    ${inicial}    Set Variable   ${valorini} 
    WHILE  ${inicial} <= ${valorfin}
        ${final}    Evaluate   ${inicial}+90000 
        input text    name:cd-from   ${inicial}
        input text    name:cd-to   ${final}
        Sleep   2
        Click element    xpath://*[@id="filtro-Precio-submit"]
        Sleep    2
#        WHILE    True
#        ${res}    Get Element Attribute    ccs:.active    innerHtml
        Log To Console    ${inicial}-${final} 
        Traer Lista    ${inicial}    ${final} 
#            Sleep    1
#            Execute Javascript    document.querySelector('.pagination-box > ul .next a').click()
#            Log To Console    Siguiente
#            Sleep    2
#        END
#        Wait Until Keyword Succeeds    5 min    30 sec    Traer Lista    ${inicial}    ${final} 
#        //*[@id="content"]/main/nav/ul/li[11]/a ***siguiente 
        ${inicial}    Evaluate   ${final}+10000
        Execute Javascript    document.getElementById('remove_item_form_142').click()
#        Click Element    path://*[@id="remove_item_form_142"]
    END
    Execute Javascript    document.getElementById('remove_item_form_145').click()
    Execute Javascript    document.querySelector('.otros-filtros').click()
#    Press Keys   None    \ue00f
Buscar
    Wait Until Keyword Succeeds    1 min    1 sec    Click should be done    xpath://*[@id="search-button"]

Traer Lista
    [Arguments]    ${ini}    ${fin}
     ${count}=  Get Element Count  xpath://*[@id="form1"]/div/article
    FOR    ${item}    IN RANGE  1   ${count}+1
        ${elem} =    Get WebElement  xpath://*[@id="form1"]/div/article[${item}]
#        ${href}=	Get Element Attribute	xpath://*[@id="form1"]/div/article[${item}]/div/div[2]/a	href
        ${title}=	Get Element Attribute	xpath://*[@id="form1"]/div/article[${item}]/div/div[2]/a	title
        ${date} =    Get Current Date    result_format=%Y%m%d
#        Create File          ${rutaimages}/${date}/${ini}-${fin}/${zona}/${title}/${item}/${item}.txt    ${href}
        Abrir anuncio    xpath://*[@id="form1"]/div/article[${item}]/div/div[2]/a    ${rutaimages}/${date}/${ini}-${fin}/${zona}/${title}/${item}    ${item}

    END

Abrir anuncio
    [Arguments]    ${aviso}    ${ruta}    ${item}
        ${href}=	Get Element Attribute	${aviso}	href
        Click Element    ${aviso}    COMMAND
        Sleep    3
        ${handles}=    Get Window Handles
        Switch Window    ${handles}[1]
        Sleep    2
        Execute Javascript    document.querySelector('#heading0 > h4 > a').click()
        TRY
        # cuando la descripcion es muy corta el boton ver mas no existe
            Execute Javascript    document.querySelector('.box-detail .descripcion > a').click()
            ${desc}=	Get Element Attribute	xpath://*[@id="rmjs-1"]/p    innerText
            Element Should Not Contain    xpath://*[@id="rmjs-1"]/p    comunitario
            Create File          ${ruta}/${item}.txt    ${href}
            Append To File    ${ruta}/${item}.txt    \n
            Append To File    ${ruta}/${item}.txt    ${desc}
            ${count}=  Get Element Count  xpath://*[@id="container"]/main/div/div[1]/div/div[1]/div[1]/div/div
            FOR    ${foto}    IN RANGE  1   ${count}+1
                ${href}=	Get Element Attribute	xpath://*[@id="container"]/main/div/div[1]/div/div[1]/div[1]/div/div[${foto}]/div/a	href
                Run Process    cd "${ruta}" && wget ${href}    shell=yes
                Log To Console    ${href}
            END
#            Sleep    1
            Capture Page Screenshot    ${ruta}/0_id_image_id-${item}.png
            Log To Console    Aviso ${item}: ${count}
        EXCEPT 
            Log To Console    La descripcion es corta o es comunitario
        END
        Close Window
        Switch Window    ${handles}[0]