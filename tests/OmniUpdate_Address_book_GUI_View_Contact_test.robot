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
GUI View Single Contact
    [Tags]    Functionality
    API Create New Entry    ${SESSIOINNAME}    Bucky    Barnes    winter@soldier.com    1234567890    123 Buchanan Way    Brooklyn    NY    11223
    Reload Page
    View Single Contact    Bucky Barnes
    API Delete Entry    ${SESSIOINNAME}    &{ID}[Bucky Barnes]
    Reload Page

*** Keywords ***
Open Address book
    Create Session    ${SESSIOINNAME}    ${API}
    Open Browser and Go to URL    ${URL}