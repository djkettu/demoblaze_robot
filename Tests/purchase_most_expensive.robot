*** Settings ***
Documentation               Purchase one each of the most expensive items in each category.
Resource                    ../Resources/demoblaze.resource

Test Setup                   Open Context and Page

*** Test Cases ***
Purchase Most Expensive From Each Category
    ${phone}=               Get Most Expensive      ${CATEGORY}[phones]
    ${phone_price}          Purchase a Product2     phones     ${phone}
    ${laptop}=              Get Most Expensive      ${CATEGORY}[laptops]
    ${laptop_price}=        Purchase a Product2     laptops    ${laptop}
    ${monitor}              Get Most Expensive      ${CATEGORY}[monitors]
    ${monitor_price}=       Purchase a Product2     monitors    ${monitor}
    ${total_price}=         Evaluate                ${phone_price * 1} + ${laptop_price * 1} + ${monitor_price * 1}
    ${total_price}          Convert To String       ${total_price}
    Go To Cart And Place Order  ${total_price}

*** Keywords ***
Get Most Expensive
    [Arguments]             ${CATEGORY_NAME}
    ${prices}=              Create List
    ${price_and_locator}=   Create List
    Go To                   ${BASEURL}
    Click                   .list-group >> "${CATEGORY_NAME}"
    Wait Until Network Is Idle
    @{product_cards} =      Get Elements       \#tbodyid >> .card-block
    FOR     ${product_card}    IN      @{product_cards}
    ${price}=               Get Text     ${product_card} >> h5
    ${price}=               Extract Numeral  ${price}
    Append To List          ${prices}   ${price}
    Append To List          ${price_and_locator}    ${price}    ${product_card}
        END
    Sort List               ${prices}
    ${prices}=              Evaluate    sorted(${prices}, key=int, reverse=True)
    ${highest_index}=       Get Index From List    ${price_and_locator}    ${prices}[0]
    ${highest_index}=       Convert To Integer    ${highest_index}
    ${pntr}=                Get From List    ${price_and_locator}    ${highest_index+1}
    ${highest_name}=        Get Text    ${pntr} >> h4 >> a
    [Return]                ${highest_name}

# This is necessary because the original keyword uses backwards logic.
Purchase a Product2
    [Arguments]             ${CATEGORY_NAME}    ${PRODUCT_NAME}
    Select Category         ${CATEGORY}[${CATEGORY_NAME}]
    ${price}=               Add Prouct to Cart      ${PRODUCT_NAME}
    # Need to add more things to the cart before finalizing the sale,
    # more backwards logic!
    # Go To Cart And Place Order      ${price}
    [Return]                ${price}