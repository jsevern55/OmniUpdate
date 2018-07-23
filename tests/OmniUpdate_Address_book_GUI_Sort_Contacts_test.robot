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
#Sorts contacts using the Web Browser
GUI Sort Contacts
    [Tags]    Functionality
    API Create New Entry    ${SESSIOINNAME}    Bruce    Banner    incredible@hulk.com    1234567890    123 Green Way    Brooklyn    NY    11223
    API Create New Entry    ${SESSIOINNAME}    Donald    Blake    thor@odinson.com    1234567890    123 Mjolnir Way    Brooklyn    NY    11223
    Reload Page
    Sleep    2
    @{contactlistxpath}    Get WebElements    ${CONTACTITEM}/descendant::div[contains(@class, 'contact-name')]
    @{contacts}    Create List
    :FOR    ${contact}    IN    @{contactlistxpath}
    \    ${contactname}    Get Text    ${contact}
    \    Append To List    ${contacts}    ${contactname}
    Sort List    ${contacts}
    Sort Contacts    @{contacts}
    API Delete Entry    ${SESSIOINNAME}    &{ID}[Bruce Banner]
    API Delete Entry    ${SESSIOINNAME}    &{ID}[Donald Blake]

*** Keywords ***
Open Address book
    Create Session    ${SESSIOINNAME}    ${API}
    Open Browser and Go to URL    ${URL}