*** Settings ***
Library     RequestsLibrary
Library     Collections

*** Variables ***
${bare_url}     http://simondfranklininshur.pythonanywhere.com
${product1}     Taxi
${product2}     Courier
${user}     adminuser
${passwd}     adminpassword

*** Test Cases ***
TC1AllProductsValidateTaxiandCourier
    create session  tc1session  ${bare_url}
    ${response} =   get request  tc1session     /products
    log to console  ${response.status_code}
    log to console  ${response.content}
    log to console  ${response.headers}
    #VALIDATIONS
    ${status_code}=     convert to string  ${response.status_code}
    should be equal     ${status_code}  200
    ${body}=    convert to string   ${response.content}
    should contain  ${body}     ${product1}
    should contain  ${body}     ${product2}

TC2RetrieveIndividualProduct
    create session  tc2session  ${bare_url}
    ${response} =   get request  tc2session     /product/1234
    log to console  ${response.status_code}
    log to console  ${response.content}
    log to console  ${response.headers}
    #VALIDATIONS
    ${body}=    convert to string   ${response.content}
    should contain  ${body}     1.0
    should contain  ${body}     Taxi

TC3RetrieveNonExistantProduct
    create session  tc3session  ${bare_url}
    ${response} =   get request  tc3session     /product/2222
    log to console  ${response.status_code}
    log to console  ${response.content}
    log to console  ${response.headers}
    #VALIDATIONS
    ${body}=    convert to string   ${response.content}
    should contain  ${body}     product 2222 not found
    ${status_code}=     convert to string  ${response.status_code}
    should be equal     ${status_code}      404

TC4FeaturesCustomers
    ${auth}=  Create List  ${user}  ${passwd}
    create session  tc4session  ${bare_url}   auth=${auth}
    ${response} =   get request  tc4session     /customers
    log to console  ${response.status_code}
    log to console  ${response.content}
    log to console  ${response.headers}
    #VALIDATIONS
    ${body}=    convert to string   ${response.content}
    should contain  ${body}     customer1
    should contain  ${body}     customer2
    should contain  ${body}     customer3
    should contain  ${body}     customer4
    should contain  ${body}     customer5
    should contain  ${body}     customer6
