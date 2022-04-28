*** Settings ***
Documentation               Resources for demoblaze.com purchase flow testing.
Library                     Browser         #enable_presenter_mode=true

*** Variables ***
${BASEURL}                  https://www.demoblaze.com
${BROWSER}                  chromium
${HEADLESS}                 false
${TIMEOUT}                  20
${VIEWPORT}                 'width':1366, 'height':768
&{TESTUSERS}                firstUser=foo
...                         secondUser=foo2
&{PASSWORDS}                firstPW=bar
...                         secondPW=bar2
${NAVBAR}                   .navbar-nav
&{CONTACT}                  modal=\#exampleModal
...                         navitem=${NAVBAR} >> "Contact"
&{SIGNIN}                   modal=\#signInModal
...                         navitem=${NAVBAR} >> "Sign In"
&{LOGIN}                    modal=\#logInModal
...                         navitem=${NAVBAR} >> "Log In"
${ABOUT}                    \#videoModal
${CART}                     ${NAVBAR} >> "Cart"
&{CATEGORY}                 phones=Phones
...                         laptops=Laptops
...                         monitors=Monitors
&{PRODUCT}                  lumia=Nokia lumia 1520
...                         macbookAir=MacBook air
...                         asusMonitor=Asus Full HD
&{TEST_CUSTOMER}            name=Terry Tester
...                         country=Testopia
...                         city=Testia
...                         card=1234567890
...                         month=12
...                         year=2022

*** Keywords ***
Open Context And Page
    Open Browser
    New Context             viewport={'width': 1366, 'height': 768}
    New Page                ${BASEURL}

Log In To Shop
    Click                   ${NAVBAR} >> \#login2
    Fill Text               \#loginusername     ${TESTUSERS}[firstUser]
    Type Secret             \#loginpassword     ${PASSWORDS}[firstPW]
    Click                   \#logInModal >> .modal-footer >> .btn-primary