# Created by alifyusof at 19/11/2024
*** Settings ***
Library    SeleniumLibrary
Suite Setup     Open Browser to SauceDemo
Suite Teardown    Close Browser
Test Setup    Maximize browser window
Test Teardown    Close All Browsers

*** Variables ***
${URL}      https://www.saucedemo.com/
${BROWSER}  chrome
${USERNAME}  standard_user
${PASSWORD}  secret_sauce
${ADD_PRODUCT_1}  @id="add-to-cart-sauce-labs-backpack"
${REMOVE_PRODUCT_1}  id=remove-sauce-labs-backpack
${ADD_PRODUCT_2}  @id="add-to-cart-sauce-labs-bike-light"
${REMOVE_PRODUCT_2}  id=remove-sauce-labs-bike-light
${PRODUCT_1}    Sauce Labs Backpack
${PRODUCT_2}    Sauce Labs Bike Light
${FIRST_NAME}    TEST
${LAST_NAME}    SauceDemo
${POSTAL_CODE}    12345
${TOTAL_PRICE_PRODUCT_1}    29.99
${TOTAL_PRICE_PRODUCT_2}    9.99

*** Keywords ***
Open Browser to SauceDemo
    [Documentation]    Open the browser and navigate to the application
    Open browser    ${URL}  ${BROWSER}
    Maximize browser window

Login To Application
    [Documentation]    Successful Login to the Application
    Input text    id=user-name  ${USERNAME}
    Input text    id=password   ${PASSWORD}
    Click button    id=login-button
    Wait until element is visible    id=inventory_container

Add Products To Cart
    [Documentation]    Add Products To Cart
    Click button    xpath=//div/button[${ADD_PRODUCT_1}]
    Wait until element is visible    ${REMOVE_PRODUCT_1}
    Click button    xpath=//div/button[${ADD_PRODUCT_2}]
    Wait until element is visible    ${REMOVE_PRODUCT_2}

Go To Cart And Validate
    [Documentation]    Go To Cart And Validate
    #Click link    xpath=//div/a[@class="shopping_cart_link"]
    Click element    xpath=//div[@id="shopping_cart_container"]
    Set selenium implicit wait    30s
    Wait until element is visible    id=checkout
    Wait until element contains    id=checkout  Checkout    timeout=30s
    ${cart_items}=  Get text    xpath=//div[@class="cart_item"][1]
    Should contain    ${cart_items}     ${PRODUCT_1}
    ${cart_items}=  Get text    xpath=//div[@class="cart_item"][2]
    Should contain    ${cart_items}     ${PRODUCT_2}
    Log    ${cart_items}

Checkout And Validate
    [Documentation]    Proceed to checkout
    Click button    xpath=//button[@id="checkout"]
    Wait until element is visible    id=checkout_info_container
    Input text    id=first-name  ${FIRST_NAME}
    Input text    id=last-name  ${LAST_NAME}
    Input text    id=postal-code  ${POSTAL_CODE}
    Click button    id=continue
    ${cart_items}=  Get text    xpath=//div[@class="cart_item"][1]
    Should contain    ${cart_items}     ${PRODUCT_1}
    ${total_price}=     Get Text    xpath=//div[@class="inventory_item_price"]
    Should contain    ${total_price}        ${TOTAL_PRICE_PRODUCT_1}
    ${cart_items_2}=  Get text    xpath=//div[@class="cart_item"][2]
    Should contain    ${cart_items_2}     ${PRODUCT_2}
    ${total_price_2}=     Get Text    xpath=//div[@class="inventory_item_price"]
    Should contain    ${total_price_2}        ${TOTAL_PRICE_PRODUCT_2}

*** Test Cases ***
Test User Can Complete Purchase
    [Documentation]    This test case will open the browser, log in
    [Tags]    UI    Checkout
    Login To Application
    Add Products To Cart
    Go To Cart And Validate
    Checkout And Validate