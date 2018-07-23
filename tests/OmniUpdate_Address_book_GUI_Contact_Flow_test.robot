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
#Creates a new contact using the Web Browser
GUI Create New Entry
    [Tags]    Functionality
    Integration Test Create Contact Module

#Updates a contact using the Web Browser
GUI Update Entry
    [Tags]    Functionality
    Integration Test Update Contact Module

#Deletes a contact using the Web Browser
GUI Delete Entry
    [Tags]    Functionality
    API Create New Entry    ${SESSIOINNAME}    Bruce    Banner    incredible@hulk.com    1234567890    123 Green Way    Brooklyn    NY    11223
    API Create New Entry    ${SESSIOINNAME}    Donald    Blake    thor@odinson.com    1234567890    123 Mjolnir Way    Brooklyn    NY    11223
    ${ToDelete}    Create List    Bruce Banner    Donald Blake    Steven Rogers
    Reload Page
    Integration Test Delete Contact    @{ToDelete}

*** Keywords ***
Open Address book
    Create Session    ${SESSIOINNAME}    ${API}
    Open Browser and Go to URL    ${URL}