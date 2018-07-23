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
API List Default Contacts
    [Tags]    API
    API List Default Contacts    ${SESSIOINNAME}

API Create New Entry
    [Tags]    API
    API Create New Entry    ${SESSIOINNAME}    Bucky    Barnes    winter@soldier.com    1234567890    123 Buchanan Way    Brooklyn    NY    11223

API List Single Entry
    [Tags]    API
    Log    &{ID}[Bucky Barnes]
    API List Single Entry    ${SESSIOINNAME}    &{ID}[Bucky Barnes]

API Update Entry
    [Tags]    API
    API Update Entry    ${SESSIOINNAME}    &{ID}[Bucky Barnes]    Steven    Rogers    captain@america.com    0987654321    123 Grant Way    Brooklyn    NY    11223

API Delete Entry
    [Tags]    API
    API Delete Entry    ${SESSIOINNAME}    &{ID}[Steven Rogers]

GUI Create New Entry
    [Tags]    Functionality
    Integration Test Create Contact Module

GUI Update Entry
    [Tags]    Functionality
    Integration Test Update Contact Module

GUI Delete Entry
    [Tags]    Functionality
    API Create New Entry    ${SESSIOINNAME}    Bruce    Banner    incredible@hulk.com    1234567890    123 Green Way    Brooklyn    NY    11223
    API Create New Entry    ${SESSIOINNAME}    Donald    Blake    thor@odinson.com    1234567890    123 Mjolnir Way    Brooklyn    NY    11223
    ${ToDelete}    Create List    Bruce Banner    Donald Blake    Steven Rogers
    Reload Page
    Integration Test Delete Contact    @{ToDelete}

GUI View Single Contact
    [Tags]    Functionality
    API Create New Entry    ${SESSIOINNAME}    Bucky    Barnes    winter@soldier.com    1234567890    123 Buchanan Way    Brooklyn    NY    11223
    Reload Page
    View Single Contact    Bucky Barnes
    API Delete Entry    ${SESSIOINNAME}    &{ID}[Bucky Barnes]
    Reload Page

GUI Sort Contacts
    [Tags]    Functionality
    API Create New Entry    ${SESSIOINNAME}    Bruce    Banner    incredible@hulk.com    1234567890    123 Green Way    Brooklyn    NY    11223
    API Create New Entry    ${SESSIOINNAME}    Donald    Blake    thor@odinson.com    1234567890    123 Mjolnir Way    Brooklyn    NY    11223
    Reload Page
    Sleep    2
    #Wait Until Element Is Visible    ${CONTACTITEM}/descendant::div[contains(@class, 'contact-name')]
    @{contactlistxpath}    Get WebElements    ${CONTACTITEM}/descendant::div[contains(@class, 'contact-name')]
    @{contacts}    Create List
    :FOR    ${contact}    IN    @{contactlistxpath}
    \    ${contactname}    Get Text    ${contact}
    \    Append To List    ${contacts}    ${contactname}
    Sort List    ${contacts}
    Sort Contacts    @{contacts}
    API Delete Entry    ${SESSIOINNAME}    &{ID}[Bruce Banner]
    API Delete Entry    ${SESSIOINNAME}    &{ID}[Donald Blake]

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