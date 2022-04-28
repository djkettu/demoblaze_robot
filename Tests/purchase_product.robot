*** Settings ***
Documentation               Testing demoblaze.com purchase flow.
Resource                    ../Resources/demoblaze.resource
Library                     Collections

Test Setup                  Open Context and Page

*** Test Cases ***
Purchase a Product
    Log In To Shop
    Select Category         ${CATEGORY}[laptops]
    Add Prouct to Cart      ${PRODUCT}[lumia]
    Go To Cart And Place Order
    #Log Out


*** Keywords ***
Select Category
    [Arguments]             ${CATEGORY_NAME}
    Go To                   ${BASEURL}
    Click                   "${CATEGORY_NAME}"

Add Prouct to Cart
    [Arguments]             ${PRODUCT_NAME}
    Click                   "${PRODUCT_NAME}"
    Get Text                //h2    ==    ${PRODUCT_NAME}
    Handle Future Dialogs   action=accept
    Click                   "Add to cart"

Go To Cart And Place Order
    Go To                   ${BASEURL}/cart.html
    Click                   "Place Order"
    Fill Text               \#name      ${TEST_CUSTOMER}[name]
    Fill Text               \#country   ${TEST_CUSTOMER}[country]
    Fill Text               \#city      ${TEST_CUSTOMER}[city]
    Fill Text               \#card      ${TEST_CUSTOMER}[card]
    Fill Text               \#month     ${TEST_CUSTOMER}[month]
    Fill Text               \#year      ${TEST_CUSTOMER}[year]
    Click                   //*[@id="orderModal"]/div/div/div[3]/button[2]
    Get Text                .sweet-alert >> h2    ==    Thank you for your purchase!
    Take Screenshot         selector=.sweet-alert
    Click                   .sweet-alert >> .sa-button-container >> "OK"

Log Out
    Click                   ${NAVBAR} >> \#logout2