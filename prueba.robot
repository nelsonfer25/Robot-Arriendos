*** Settings ***
Library  OperatingSystem
Library  SeleniumLibrary
Library  DateTime
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
#    Traer Lista
    Navegador
    Filtro
    Zona Sur
    Buscar
    Precios
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
Navegador
    Open browser    ${pagina}  ${navegador}

Cambiar zona
    [Arguments]    ${name}    ${path}
    Log    Entro por aca ${name}
    Click Element    ${path}
    Sleep    1
    [Return]    ${name}
Filtro
    Click element    xpath://*[@id="config_operationtype"]/option[3]
    Sleep   1
    Click element    xpath://*[@id="config_advicetype"]/option[3]
    Sleep   1
    Click element    xpath://*[@id="select_99"]/option[31]
    Sleep   1
    Click Element    xpath://*[@id="select_100"]/option[11]
    Sleep   1

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
Buscar
    Click element    xpath://*[@id="search-button"]

Traer Lista
    [Arguments]    ${ini}    ${fin}
     ${count}=  Get Element Count  xpath://*[@id="form1"]/div/article
    FOR    ${item}    IN RANGE  1   ${count}+1
        ${elem} =    Get WebElement  xpath://*[@id="form1"]/div/article[${item}]
        ${href}=	Get Element Attribute	xpath://*[@id="form1"]/div/article[${item}]/div/div[2]/a	href
        ${title}=	Get Element Attribute	xpath://*[@id="form1"]/div/article[${item}]/div/div[2]/a	title
        ${date} =    Get Current Date    result_format=%Y%m%d
        Create File          ${rutaimages}/${date}/${ini}-${fin}/${zona}/${title}/${item}.txt    ${href}
#        Capture Element Screenshot	${elem}	${rutaimages}/${date}/${ini}-${fin}/${zona}/${title}/id_image_id-${item}.png
        Click Element    xpath://*[@id="form1"]/div/article[${item}]/div/div[2]/a    COMMAND
        Sleep    3
        ${handles}=    Get Window Handles
        Switch Window    ${handles}[1]
        Sleep    2
        Execute Javascript    document.querySelector('#heading0 > h4 > a').click()
        Execute Javascript    document.querySelector('.box-detail .descripcion > a').click()
        Sleep    1
        ${desc}=	Get Element Attribute	xpath://*[@id="rmjs-1"]/p    innerText
        Append To File    ${rutaimages}/${date}/${ini}-${fin}/${zona}/${title}/${item}.txt    \n
        Append To File    ${rutaimages}/${date}/${ini}-${fin}/${zona}/${title}/${item}.txt    ${desc}
        Capture Page Screenshot    ${rutaimages}/${date}/${ini}-${fin}/${zona}/${title}/id_image_id-${item}.png
        Close Window
        Switch Window    ${handles}[0]
        Log To Console    ${title}
#        Open Browser    ${href}    ${navegador}
#        Sleep    3
#        ${handles}=    Get Window Handles
#        Switch Window    ${handles}[0]
#        Switch Window    ${handles}[1]
#        Close Window
#        Click Link  ${elem}
#        Switch Window    title:nueva
#        Click element      ${elem}
    END
 #   ${este}    Get WebElement    css:.next >> xpath://a
 #   Log To Console    ${este}
 #   Click Element    ${este}
#    ${condition}    Page Should Contain Element    xpath://*[@id="content"]/main/nav
#    Run Keyword If    'FAIL' in ${condition}    Execute Javascript    document.querySelector('.pagination-box > ul .next a').click()
#    Get WebElement    xpath//*[@id="content"]/main/nav/ul/li[11]
#    Run Keyword If    ${condition}    click element    xpath://*[@id="content"]/main/nav/ul/li[11]/a
#    Page Should Not Contain Element    xpath://*[@id="content"]/main/nav/ul/li[11]/a
#    Close Window
#    ${locator_list} =	Get WebElement	xpath://*[@id="form1"]/div/article
#    Log To Console  ${locator_list}
#    Page Should Contain Element	${locator_list}
#    ${values} =	Get List Items	xpath://*[@id="form1" and ./div/article]
#    ${elem} =	Get WebElement  xpath://*[@id="form1"]/div/article
#    Click element    ${element}
#    //*[@id="content"]/div[1]/div/div[1]/ol/li[3]/span