*** Settings ***
Documentation    This is a test case for OmniUpdate Address Book

Resource          resource-Chrome.robot
Suite Setup       Open API Address book
Suite Teardown    Close Browser

*** Variables ***
${URL}                      http://jr-qa.oudemo.com/
${API}                      http://front-end.oudemo.com/api
${SESSIOINNAME}             AddressBook

*** Test Case ***
#Runs API Post to create a new contact. The output is printed in JSON format, and can be found in the Log file as the last step in this task.
API Create New Entry
    [Tags]    API
    API Create New Entry    ${SESSIOINNAME}    Bucky    Barnes    winter@soldier.com    1234567890    123 Buchanan Way    Brooklyn    NY    11223

#Runs API Get to list all available contacts. The output is printed in JSON format, and can be found in the Log file as the last step in this task.
API List Contacts
    [Tags]    API
    API List Contacts    ${SESSIOINNAME}

#Runs API Get to list a single entry in the Address book. The output is printed in JSON format, and can be found in the Log file as the last step in this task.
API List Single Entry
    [Tags]    API
    Log    &{ID}[Bucky Barnes]
    API List Single Entry    ${SESSIOINNAME}    &{ID}[Bucky Barnes]

#Runs API Post to Update an existing Address book entry. The output is printed in JSON format, and can be found in the Log file as the last step in this task.
API Update Entry
    [Tags]    API
    API Update Entry    ${SESSIOINNAME}    &{ID}[Bucky Barnes]    Steven    Rogers    captain@america.com    0987654321    123 Grant Way    Brooklyn    NY    11223

#Runs API Post to Delete existing Address book entry. The output is printed in JSON format, and can be found in the Log file as the last step in this task.
API Delete Entry
    [Tags]    API
    API Delete Entry    ${SESSIOINNAME}    &{ID}[Steven Rogers]

*** Keywords ***
Open API Address book
    Create Session    ${SESSIOINNAME}    ${API}