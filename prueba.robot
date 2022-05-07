*** Settings ***
Library  OperatingSystem
Library  SeleniumLibrary
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
    Traer Lista
    Navegador
    Filtro
    Zona Sur
    Buscar
    Precios
    Traer Lista
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
    input text    name:cd-from   ${valorini}
    input text    name:cd-to   ${valorfin}
    Sleep   1
    Click element    xpath://*[@id="filtro-Precio-submit"]
Buscar
    Click element    xpath://*[@id="search-button"]

Traer Lista
     ${count}=  Get Element Count  xpath://*[@id="form1"]/div/article
    FOR    ${item}    IN RANGE  1   ${count}+1
        ${elem} =    Get WebElement  xpath://*[@id="form1"]/div/article[${item}]
        ${href}=	Get Element Attribute	xpath://*[@id="form1"]/div/article[${item}]/div/div[2]/a	href
        ${title}=	Get Element Attribute	xpath://*[@id="form1"]/div/article[${item}]/div/div[2]/a	title
        Create File          ${rutaimages}/${zona}/${title}/${item}.txt    ${href}
        Capture Element Screenshot	${elem}	${rutaimages}/${zona}/${title}/id_image_id-${item}.png
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
    Close Window
#    ${locator_list} =	Get WebElement	xpath://*[@id="form1"]/div/article
#    Log To Console  ${locator_list}
#    Page Should Contain Element	${locator_list}
#    ${values} =	Get List Items	xpath://*[@id="form1" and ./div/article]
#    ${elem} =	Get WebElement  xpath://*[@id="form1"]/div/article
#    Click element    ${element}
#    //*[@id="content"]/div[1]/div/div[1]/ol/li[3]/span