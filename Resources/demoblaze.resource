*** Settings ***
Documentation                       Resources for demoblaze.com purchase flow testing.
Library                             Browser         #enable_presenter_mode=true

*** Variables ***
${BASEURL}                          https://www.demoblaze.com
${BROWSER}                          chromium
${HEADLESS}                         false
${TIMEOUT}                          20
${VIEWPORT}                         'width':1366, 'height':768
&{TESTUSERS}                        firstUser=foo
...                                 secondUser=foo2
&{PASSWORDS}                        firstPW=bar
...                                 secondPW=bar2
${NAVBAR}                           .navbar-nav
&{CONTACT}                          modal=\#exampleModal
...                                 navitem=${NAVBAR} >> "Contact"
&{SIGNIN}                           modal=\#signInModal
...                                 navitem=${NAVBAR} >> "Sign In"
&{LOGIN}                            modal=\#logInModal
...                                 navitem=${NAVBAR} >> "Log In"
${ABOUT}                            \#videoModal
${CART}                             ${NAVBAR} >> "Cart"
&{CATEGORY}                         phones=Phones
...                                 laptops=Laptops
...                                 monitors=Monitors
&{PRODUCT}                          lumia=Nokia lumia 1520
...                                 macbookAir=MacBook air
...                                 asusMonitor=Asus Full HD
&{TEST_CUSTOMER}                    name=Terry Tester
...                                 country=Testopia
...                                 city=Testia
...                                 card=1234567890
...                                 month=12
...                                 year=2022

*** Keywords ***
Open Context And Page
    # Start Watch
    New Browser
    New Context                     viewport={'width': 1366, 'height': 768}
    New Page                        ${BASEURL}
    # Log Time                        New Browser

Log In To Shop
    Click                           ${NAVBAR} >> \#login2
    Fill Text                       \#loginusername     ${TESTUSERS}[firstUser]
    Type Secret                     \#loginpassword     ${PASSWORDS}[firstPW]
    Click                           \#logInModal >> .modal-footer >> .btn-primary

Select Category
    [Arguments]                     ${CATEGORY_NAME}
    Go To                           ${BASEURL}
    Click                           "${CATEGORY_NAME}"

Add Prouct to Cart
    [Arguments]                     ${PRODUCT_NAME}
    Click                           "${PRODUCT_NAME}"
    Get Text                        //h2    ==    ${PRODUCT_NAME}
    ${price}=                       Get Text      .price-container
    ${price}=                       Extract Numeral  ${price}
    Click                           "Add to cart"
    Wait For alert                  action=accept
    [Return]                        ${price}

Go To Cart And Place Order
    [Arguments]                     ${price}
    Go To                           ${BASEURL}/cart.html
    Wait For Elements State         \#totalp   visible
    Get Text                        \#totalp    ==    ${price}
    Click                           .btn-success
    Fill Text                       \#name      ${TEST_CUSTOMER}[name]
    Fill Text                       \#country   ${TEST_CUSTOMER}[country]
    Fill Text                       \#city      ${TEST_CUSTOMER}[city]
    Fill Text                       \#card      ${TEST_CUSTOMER}[card]
    Fill Text                       \#month     ${TEST_CUSTOMER}[month]
    Fill Text                       \#year      ${TEST_CUSTOMER}[year]
    Click                           .modal-content >> .modal-footer >> "Purchase"
    Get Text                        .sweet-alert >> h2    ==    Thank you for your purchase!
    Take Screenshot                 selector=.sweet-alert
    Click                           .sweet-alert >> .sa-button-container >> "OK"

Purchase a Product
    [Tags]                  UI    
    [Arguments]                     ${CATEGORY_NAME}    ${PRODUCT_NAME}
    Log In To Shop
    Select Category                 ${CATEGORY}[${CATEGORY_NAME}]
    ${price}=                       Add Prouct to Cart      ${PRODUCT}[${PRODUCT_NAME}]
    Go To Cart And Place Order      ${price}

Log Out
    Click                           ${NAVBAR} >> \#logout2

Extract Numeral
    [Arguments]                     ${string}
    @{split_string}                 Split String        ${string}
    ${string_numeral}               Get From List       ${split_string}      0
    ${string_numeral}=              Fetch From Right    ${string_numeral}    $
    [Return]                        ${string_numeral}