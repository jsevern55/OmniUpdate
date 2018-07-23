*** Settings ***
Documentation    This is a test case for OmniUpdate Address Book

Resource          resource-Chrome.robot
Suite Setup       Open Address book
Suite Teardown    Close Browser

*** Variables ***
${URL}                      http://jr-qa.oudemo.com/
${API}                      http://front-end.oudemo.com/api
${SESSIOINNAME}             AddressBook

*** Test Case ***
GUI Filter Contacts
    [Tags]    Functionality
    API Create New Entry    ${SESSIOINNAME}    Bruce    Banner    incredible@hulk.com    1234567890    123 Green Way    Brooklyn    NY    11223
    API Create New Entry    ${SESSIOINNAME}    Donald    Blake    thor@odinson.com    1234567890    123 Mjolnir Way    Brooklyn    NY    11223
    Reload Page
    @{firstNames}    Create List    Bruce    Donald
    @{lastNames}    Create List    Banner    Blake
    @{emails}    Create List    incredible@hulk.com    thor@odinson.com
    Filter Contacts    ${firstNames}    ${lastNames}    ${emails}
    API Delete Entry    ${SESSIOINNAME}    &{ID}[Bruce Banner]
    API Delete Entry    ${SESSIOINNAME}    &{ID}[Donald Blake]

*** Keywords ***
Open Address book
    Create Session    ${SESSIOINNAME}    ${API}
    Open Browser and Go to URL    ${URL}