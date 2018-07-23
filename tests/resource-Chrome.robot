*** Settings ****
Documentation    This file is used to store common keywords and variables that can be utilized by any test cases that uses this file as a resource
Library           SeleniumLibrary
Library           RequestsLibrary
Library           String
Library           Collections

*** Variables ***
${BROWSER}                  Chrome
&{ID}
@{MATCHES}
@{EMAILMATCHES}
${APIKEY}                   39c91efd-ba3f-42fe-a76a-642aafd32883
${NUMBEROFCONTACTS}         //div[contains(@class, 'contact-item')]
${NUMBEROFCONTACTSXPATH}    xpath=//div[contains(@class, 'contact-item')]
${CREATECONTACT}            xpath=//button[contains(@class, 'add-contact-btn')]
${CREATEMODULE}             xpath=//div[@id='create-view']
${EDITCONTACT}              xpath=//button[contains(@class, 'edit-contact-btn')]
${EDITMODULE}               xpath=//div[@id='edit-view']
${DISPLAYMODULE}            xpath=//div[@id='display-view']
${CONTACTLIST}              xpath=//div[@class='contact-list']
${CONTACTITEM}              xpath=//div[@class='contact-list']/descendant::div[contains(@class, 'contact-item')]
${MULTISELECT}              xpath=//div[contains(@class, 'multi-select-btn')]
${DELETECONTACTFLOAT}       xpath=//button[contains(@class, 'delete-contact-btn float-btn')]
${MODALCONFIRM}             xpath=//div[contains(@class, 'modal-btn confirm-btn')]
${SORTBUTTON}               xpath=//div[contains(@class, 'sort-btn')]
${SORTFIRSTNAME}            xpath=//div[contains(@class, 'sort-toggle') and contains(@ng-class, 'firstName')]
${SORTLASTNAME}             xpath=//div[contains(@class, 'sort-toggle') and contains(@ng-class, 'lastName')]
${SORTEMAIL}                xpath=//div[contains(@class, 'sort-toggle') and contains(@ng-class, 'email')]
${SEARCHINPUT}              xpath=//input[contains(@ng-model, 'query')]
${FILTERBUTTON}             xpath=//div[contains(@class, 'filter-btn')]

*** Keywords ***
Open Browser and Go to URL
    [Arguments]    ${URL}
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Speed    0

API List Default Contacts
    [Arguments]    ${session}
    ${resp}    Get Request    ${session}    /address/list    params=apikey=${APIKEY}
    Should Be True    '${resp.status_code}' == '200'
    Prettify JSON    ${resp.json()}
    ${AddressBook}    Set Variable    ${JSON}
    Log    ${AddressBook}

API List Single Entry
    [Arguments]    ${session}    ${idx}
    Log    ${idx}
    ${resp}    Get Request    ${session}    /address/view    params=apikey=${APIKEY}&id=${id}
    Should Be True    '${resp.status_code}' == '200'
    Prettify JSON    ${resp.json()}
    ${SingleEntry}    Set Variable    ${JSON}
    Log    ${SingleEntry}

API Create New Entry
    [Arguments]    ${session}    ${firstName}    ${lastName}    ${email}    ${phone}    ${address}    ${city}    ${state}    ${zipcode}
    ${resp}    Post Request    ${session}    /address/new    data={"apikey": "${APIKEY}", "firstName": "${firstName}", "lastName": "${lastName}", "email": "${email}", "phone": ${phone}, "address": "${address}", "city": "${city}", "state": "${state}", "zipcode": "${zipcode}"}
    Should Be True    '${resp.status_code}' == '200'
    Prettify JSON    ${resp.json()}
    ${NewEntry}    Set Variable    ${JSON}
    ${first&last}    Catenate    ${firstName}${SPACE}${lastName}
    Get New Entry ID    ${NewEntry}    ${first&last}
    Log    ${NewEntry}

API Update Entry
    [Arguments]    ${session}    ${idx}    ${firstName}    ${lastName}    ${email}    ${phone}    ${address}    ${city}    ${state}    ${zipcode}
    ${resp}    Post Request    ${session}    /address/update    data={"apikey": "${APIKEY}", "id": "${idx}", "firstName": "${firstName}", "lastName": "${lastName}", "email": "${email}", "phone": "${phone}", "address": "${address}", "city": "${city}", "state": "${state}", "zipcode": "${zipcode}"}
    Should Be True    '${resp.status_code}' == '200'
    ${json}    Convert To String    ${resp.json()}
    Prettify JSON    ${resp.json()}
    ${UpdatedEntry}    Set Variable    ${JSON}
    Should Match Regexp    ${UpdatedEntry}    (\\"firstName\\"\\:\\s\\"Steven\\")
    Should Match Regexp    ${UpdatedEntry}    (\\"email\\"\\:\\s\\"captain\\@america\\.com\\")
    ${first&last}    Catenate    ${firstName}${SPACE}${lastName}
    :FOR    ${key}    IN    @{ID.keys()}
    \    Run Keyword If    '&{ID}[${key}]' == '${idx}'    Remove From Dictionary    ${ID}    ${key}
    Set To Dictionary    ${ID}    ${first&last}    ${idx}
    Log    ${UpdatedEntry}

API Delete Entry
    [Arguments]    ${session}    ${idx}
    ${resp}    Post Request    ${session}    /address/delete    data={"apikey": "${APIKEY}", "id": "${idx}"}
    Should Be True    '${resp.status_code}' == '200'
    Should Be Equal As Strings    ${resp.json()}    {u\'message\': u\'success\'}
    Log    ${resp.json()}

Integration Test Create Contact Module
    Wait Until Element Is Visible    ${CREATECONTACT}    10
    Click Button    ${CREATECONTACT}
    Wait Until Element Is Visible    ${CREATEMODULE}    10
    Wait Until Element Is Visible    ${CREATEMODULE}/descendant::button[contains(text(), 'CANCEL')]    10
    Click Button    ${CREATEMODULE}/descendant::button[contains(text(), 'CANCEL')]
    Wait Until Element Is Not Visible    ${CREATEMODULE}    10
    Wait Until Element Is Visible    ${CREATECONTACT}    10
    Click Button    ${CREATECONTACT}
    Wait Until Element Is Visible    ${CREATEMODULE}/descendant::input[contains(@ng-model, 'firstName')]
    Click Element    ${CREATEMODULE}/descendant::input[contains(@ng-model, 'firstName')]
    Click Element    ${CREATEMODULE}/descendant::input[contains(@ng-model, 'lastName')]
    Wait Until Element Is Visible    ${CREATEMODULE}/descendant::input[contains(@ng-model, 'firstName')]/following::div[contains(@class,'error-msg') and contains(@ng-show, 'firstName.$invalid')]
    Input Text    ${CREATEMODULE}/descendant::input[contains(@ng-model, 'firstName')]    Bucky
    Click Element    ${CREATEMODULE}/descendant::input[contains(@ng-model, 'lastName')]
    Wait Until Element Is Not Visible    ${CREATEMODULE}/descendant::input[contains(@ng-model, 'firstName')]/following::div[contains(@class,'error-msg') and contains(@ng-show, 'firstName.$invalid')]
    Input Text    ${CREATEMODULE}/descendant::input[contains(@ng-model, 'lastName')]    Barnes
    Phone Field Validation for Creating a contact
    Email Field Validation for Creating a contact
    Input Text    ${CREATEMODULE}/descendant::input[contains(@ng-model, 'phone')]    0987654321
    Input Text    ${CREATEMODULE}/descendant::input[contains(@ng-model, 'email')]    winter@soldier.com
    Click Element    ${CREATEMODULE}/descendant::a[contains(@class, 'more-label')]
    Wait Until Element Is Visible    ${CREATEMODULE}/descendant::input[contains(@ng-model, 'address')]
    Wait Until Element Is Visible    ${CREATEMODULE}/descendant::input[contains(@ng-model, 'city')]
    Wait Until Element Is Visible    ${CREATEMODULE}/descendant::input[contains(@ng-model, 'state')]
    Wait Until Element Is Visible    ${CREATEMODULE}/descendant::input[contains(@ng-model, 'zip')]
    Input Text    ${CREATEMODULE}/descendant::input[contains(@ng-model, 'address')]    123 Buchanan Way
    Input Text    ${CREATEMODULE}/descendant::input[contains(@ng-model, 'city')]    Brooklyn
    Input Text    ${CREATEMODULE}/descendant::input[contains(@ng-model, 'state')]    NY
    Input Text    ${CREATEMODULE}/descendant::input[contains(@ng-model, 'zip')]    11223
    Click Button    ${CREATEMODULE}/descendant::button[contains(text(), 'SAVE')]
    Wait Until Element Is Visible    ${DISPLAYMODULE}/descendant::div[contains(text(), 'Bucky Barnes')]    10
    Wait Until Element Is Visible    ${CONTACTLIST}/descendant::div[contains(@class, 'contact-name') and contains(text(), 'Bucky Barnes')]    10
    Click Element    ${DISPLAYMODULE}/descendant::div[contains(@class, 'back-btn')]

Integration Test Update Contact Module
    Click Element    ${CONTACTLIST}/descendant::div[contains(@class, 'contact-name') and contains(text(), 'Bucky Barnes')]/following::div[contains(@class, 'more-btns')][1]
    Wait Until Element Is Visible    ${CONTACTLIST}/descendant::div[contains(@class, 'contact-name') and contains(text(), 'Bucky Barnes')]/following::div[contains(@class, 'more-btns edit-btn')][1]
    Click Element    ${CONTACTLIST}/descendant::div[contains(@class, 'contact-name') and contains(text(), 'Bucky Barnes')]/following::div[contains(@class, 'more-btns edit-btn')][1]
    Wait Until Element Is Visible    ${EDITMODULE}/descendant::button[contains(text(), 'CANCEL')]    10
    Click Button    ${EDITMODULE}/descendant::button[contains(text(), 'CANCEL')]
    Wait Until Element Is Visible    ${EDITCONTACT}    10
    Click Button    ${EDITCONTACT}
    Wait Until Element Is Visible    ${EDITMODULE}/descendant::input[contains(@ng-model, 'firstName')]
    Input Text    ${EDITMODULE}/descendant::input[contains(@ng-model, 'firstName')]    Steven
    Input Text    ${EDITMODULE}/descendant::input[contains(@ng-model, 'lastName')]    Rogers
    Run Keyword And Continue On Failure    Phone Field Validation for Updating a contact
    Run Keyword And Continue On Failure    Email Field Validation for Updating a contact
    Wait Until Element Is Visible    ${EDITMODULE}/descendant::input[contains(@ng-model, 'phone')]
    Input Text    ${EDITMODULE}/descendant::input[contains(@ng-model, 'phone')]    0987654321
    Input Text    ${EDITMODULE}/descendant::input[contains(@ng-model, 'email')]    captain@america.com
    Click Element    ${EDITMODULE}/descendant::a[contains(@class, 'more-label')]
    Wait Until Element Is Visible    ${EDITMODULE}/descendant::input[contains(@ng-model, 'address')]
    Wait Until Element Is Visible    ${EDITMODULE}/descendant::input[contains(@ng-model, 'city')]
    Wait Until Element Is Visible    ${EDITMODULE}/descendant::input[contains(@ng-model, 'state')]
    Wait Until Element Is Visible    ${EDITMODULE}/descendant::input[contains(@ng-model, 'zip')]
    Input Text    ${EDITMODULE}/descendant::input[contains(@ng-model, 'address')]    123 Grant Way
    Input Text    ${EDITMODULE}/descendant::input[contains(@ng-model, 'city')]    Brooklyn
    Input Text    ${EDITMODULE}/descendant::input[contains(@ng-model, 'state')]    NY
    Input Text    ${EDITMODULE}/descendant::input[contains(@ng-model, 'zip')]    11223
    Click Button    ${EDITMODULE}/descendant::button[contains(text(), 'UPDATE')]
    Wait Until Element Is Visible    ${CONTACTLIST}/descendant::div[contains(@class, 'contact-name') and contains(text(), 'Steven Rogers')]
    Wait Until Element Is Visible    ${DISPLAYMODULE}/descendant::div[contains(@class, 'back-btn')]
    Click Element    ${DISPLAYMODULE}/descendant::div[contains(@class, 'back-btn')]

Integration Test Delete Contact
    [Arguments]    @{deleteables}
    Wait Until Element Is Visible    ${CONTACTLIST}/descendant::div[contains(@class, 'contact-name')]
    Wait Until Element Is Visible    ${CONTACTLIST}/descendant::div[contains(@class, 'contact-name') and contains(text(), '${deleteables[0]}')]/following::div[contains(@class, 'more-btns')][1]
    Wait Until Element Is Visible    ${CONTACTLIST}/descendant::div[contains(@class, 'contact-name') and contains(text(), '${deleteables[1]}')]/following::div[contains(@class, 'more-btns')][1]
    Click Element    ${CONTACTLIST}/descendant::div[contains(@class, 'contact-name') and contains(text(), '${deleteables[0]}')]/following::div[contains(@class, 'more-btns')][1]
    Wait Until Element Is Visible    ${CONTACTLIST}/descendant::div[contains(@class, 'contact-name') and contains(text(), '${deleteables[0]}')]/following::div[contains(@class, 'more-btns delete-btn')][1]
    Click Element    ${CONTACTLIST}/descendant::div[contains(@class, 'contact-name') and contains(text(), '${deleteables[0]}')]/following::div[contains(@class, 'more-btns delete-btn')][1]
    Wait Until Element Is Visible    ${MODALCONFIRM}
    Click Element    ${MODALCONFIRM}
    Wait Until Element Is Not Visible    ${CONTACTLIST}/descendant::div[contains(@class, 'contact-name') and contains(text(), '${deleteables[0]}')]
    Wait Until Element Is Visible    ${MULTISELECT}
    Click Element    ${MULTISELECT}
    Wait Until Element Is Visible    ${CONTACTLIST}/descendant::div[contains(text(), '${deleteables[1]}')]/preceding::div[contains(@ng-show, 'multiSelect')][1]
    Wait Until Element Is Visible    ${CONTACTLIST}/descendant::div[contains(text(), '${deleteables[2]}')]/preceding::div[contains(@ng-show, 'multiSelect')][1]
    Click Element    ${CONTACTLIST}/descendant::div[contains(text(), '${deleteables[1]}')]/preceding::div[contains(@ng-show, 'multiSelect')][1]
    Click Element    ${CONTACTLIST}/descendant::div[contains(text(), '${deleteables[2]}')]/preceding::div[contains(@ng-show, 'multiSelect')][1]
    Wait Until Element Is Visible    ${DELETECONTACTFLOAT}
    Click Button    ${DELETECONTACTFLOAT}
    Wait Until Element Is Visible    ${MODALCONFIRM}
    Click Element    ${MODALCONFIRM}
    ${result1}    Run Keyword And Return Status    Wait Until Element Is Not Visible    ${CONTACTLIST}/descendant::div[contains(@class, 'contact-name') and contains(text(), '${deleteables[1]}')]
    ${result2}    Run Keyword And Return Status    Wait Until Element Is Not Visible    ${CONTACTLIST}/descendant::div[contains(@class, 'contact-name') and contains(text(), '${deleteables[2]}')]

View Single Contact
    [Arguments]    ${contact}
    Wait Until Element Is Visible    ${CONTACTLIST}/descendant::div[contains(@class, 'contact-name') and contains(text(), '${contact}')]
    Click Element    ${CONTACTLIST}/descendant::div[contains(@class, 'contact-name') and contains(text(), '${contact}')]
    Wait Until Element Is Visible    ${DISPLAYMODULE}
    Click Element    ${DISPLAYMODULE}/descendant::div[contains(@class, 'back-btn')]
    Wait Until Element Is Not Visible    ${DISPLAYMODULE}

Sort Contacts
    [Arguments]    @{sortables}
    Log List    ${sortables}
    Log    ${sortables[0]}
    Log    ${sortables[1]}
    Wait Until Element Is Visible    ${SORTBUTTON}
    Click Element    ${SORTBUTTON}
    Wait Until Element Is Visible    ${SORTFIRSTNAME}
    Wait Until Element Is Visible    ${SORTLASTNAME}
    Wait Until Element Is Visible    ${SORTEMAIL}
    Wait Until Element Is Visible    ${CONTACTLIST}/descendant::div[contains(@class, 'contact-item')]/descendant::div[contains(@class, 'contact-name') and contains(text(), '${sortables[0]}')]/following::div[contains(@class, 'contact-name') and contains(text(), '${sortables[1]}')]
    Click Element    ${SORTFIRSTNAME}
    Wait Until Element Is Visible    ${CONTACTLIST}/descendant::div[contains(@class, 'contact-item')]/descendant::div[contains(@class, 'contact-name') and contains(text(), '${sortables[1]}')]/following::div[contains(@class, 'contact-name') and contains(text(), '${sortables[0]}')]
    Click Element    ${SORTLASTNAME}
    Wait Until Element Is Visible    ${CONTACTLIST}/descendant::div[contains(@class, 'contact-item')]/descendant::div[contains(@class, 'contact-name') and contains(text(), '${sortables[0]}')]/following::div[contains(@class, 'contact-name') and contains(text(), '${sortables[1]}')]
    Click Element    ${SORTLASTNAME}
    Wait Until Element Is Visible    ${CONTACTLIST}/descendant::div[contains(@class, 'contact-item')]/descendant::div[contains(@class, 'contact-name') and contains(text(), '${sortables[1]}')]/following::div[contains(@class, 'contact-name') and contains(text(), '${sortables[0]}')]
    Click Element    ${SORTEMAIL}
    Wait Until Element Is Visible    ${CONTACTLIST}/descendant::div[contains(@class, 'contact-item')]/descendant::div[contains(@class, 'contact-name') and contains(text(), '${sortables[0]}')]/following::div[contains(@class, 'contact-name') and contains(text(), '${sortables[1]}')]
    Click Element    ${SORTEMAIL}
    Wait Until Element Is Visible    ${CONTACTLIST}/descendant::div[contains(@class, 'contact-item')]/descendant::div[contains(@class, 'contact-name') and contains(text(), '${sortables[1]}')]/following::div[contains(@class, 'contact-name') and contains(text(), '${sortables[0]}')]

Filter Contacts
    [Arguments]    ${firstName}    ${lastName}    ${email}
    Wait Until Element Is Visible    ${SEARCHINPUT}
    Wait Until Element Is Visible    ${FILTERBUTTON}
    Wait Until Element Is Visible    ${CONTACTLIST}/descendant::div[contains(@class, 'contact-name')]
    Click Element    ${FILTERBUTTON}
    Search Strings    ${firstName}
    Search Strings    ${lastName}
    Search Strings    ${email}

Search Strings
    [Arguments]    ${list}
    :FOR    ${items}    IN    @{list}
    \    Clear Element Text    ${SEARCHINPUT}
    \    Input Text   ${SEARCHINPUT}    ${items}
    \    Sleep    500ms
    \    ${name}    Get Text    ${CONTACTLIST}/descendant::div[contains(@class, 'contact-name')]
    \    ${email}    Get Text    ${CONTACTLIST}/descendant::div[contains(@class, 'contact-email')]
    \    ${result1}    ${r1}    Run Keyword And Ignore Error    Should Contain    ${name}    ${items}
    \    ${result2}    ${r2}    Run Keyword If    '${result1}' == 'FAIL'    Run Keyword And Ignore Error    Should Contain    ${email}    ${items}
    \    Run Keyword If    '${result1}' == 'FAIL' and '${result2}' == 'FAIL'    Wait Until Element Is Not Visible    ${CONTACTLIST}/descendant::div[contains(@class, 'contact-name') and contains(text(), '${name}')]
    \    Run Keyword If    '${result1}' == 'PASS' or '${result2}' == 'PASS'    Wait Until Element Is Visible    ${CONTACTLIST}/descendant::div[contains(@class, 'contact-name') and contains(text(), '${name}')]

Email Field Validation for Creating a contact
    @{possibilities}    Create List    test@test.com    a    1    .    t@t.com    t!@t.com    t1@t.com    !t@t.com    1t@t.com    t.t.t@t.t.t.com    te@t1.com    .te@t.com    te.@t.com    11@1.com    _t@t.com    t_@t.com    _t_t@t.com    t_t@t_t.com
    Click Element    ${CREATEMODULE}/descendant::input[contains(@ng-model, 'email')]
    Click Element    ${CREATEMODULE}/descendant::input[contains(@ng-model, 'phone')]
    ${errormsg}    Set Variable    /descendant::input[contains(@ng-model, 'email')]/following::div[contains(@class,'error-msg') and contains(@ng-show, 'email.$invalid')]
    ${attribute}    Get Element Attribute    ${CREATEMODULE}/descendant::input[contains(@ng-model, 'email')]    ng-pattern
    ${p}    Convert To String    ${attribute}
    ${pattern}    Replace String    ${p}    /    ${EMPTY}
    Click Element    ${CREATEMODULE}/descendant::input[contains(@ng-model, 'email')]
    Click Element    ${CREATEMODULE}/descendant::input[contains(@ng-model, 'phone')]
    :FOR    ${options}    IN    @{possibilities}
    \    #${return}    Get Regexp Matches    ${options}    ${pattern}
    \    #${returnstring}=    Run Keyword If    ${return} is not None and ${return} != []    Set Variable   @{return}[0]
    \    #Run Keyword If    ${returnstring} is not None    Append To List    ${matches}    ${options}
    \    Input Text    ${CREATEMODULE}/descendant::input[contains(@ng-model, 'email')]    ${options}
    \    Sleep    500ms
    \    ${result}    ${r}    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${CREATEMODULE}${errormsg}    1
    \    Run Keyword If    '${result}' == 'FAIL'    Append To List    ${EMAILMATCHES}    ${options}
    \    Clear Element Text    ${CREATEMODULE}/descendant::input[contains(@ng-model, 'email')]
    Set Global Variable    @{EMAILMATCHES}

Phone Field Validation for Creating a contact
    @{possibilities}    Create List    1234567890    .    -    +    1    12    123    1234    12345    12345    123456    1234567    12345678    123456789    123.456.7890    123-456-7890    123+456+7890    +1234567890    -1234567890    .1234567890    .1234567890.    .123456789+    .1234567890-    +1234567890+    +1234567890.    -1234567890.    +1234567890-    -1234567890+    -1234567890-
    Click Element    ${CREATEMODULE}/descendant::input[contains(@ng-model, 'phone')]
    Click Element    ${CREATEMODULE}/descendant::input[contains(@ng-model, 'email')]
    ${errormsg}    Set Variable    /descendant::input[contains(@ng-model, 'phone')]/following::div[contains(@class,'error-msg') and contains(@ng-show, 'phone.$invalid')]
    ${attribute}    Get Element Attribute    ${CREATEMODULE}/descendant::input[contains(@ng-model, 'phone')]    ng-pattern
    ${p}    Convert To String    ${attribute}
    ${pattern}    Replace String    ${p}    /    ${EMPTY}
    Click Element    ${CREATEMODULE}/descendant::input[contains(@ng-model, 'phone')]
    Click Element    ${CREATEMODULE}/descendant::input[contains(@ng-model, 'email')]
    :FOR    ${options}    IN    @{possibilities}
    \    #${return}    Get Regexp Matches    ${options}    ${pattern}
    \    #${returnstring}=    Run Keyword If    ${return} is not None and ${return} != []    Set Variable   @{return}[0]
    \    #Run Keyword If    ${returnstring} is not None    Append To List    ${matches}    ${options}
    \    Input Text    ${CREATEMODULE}/descendant::input[contains(@ng-model, 'phone')]    ${options}
    \    ${result}    ${r}    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${CREATEMODULE}${errormsg}    1
    \    Run Keyword If    '${result}' == 'FAIL'    Append To List    ${MATCHES}    ${options}
    \    Clear Element Text    ${CREATEMODULE}/descendant::input[contains(@ng-model, 'phone')]
    Set Global Variable    @{MATCHES}

Email Field Validation for Updating a contact
    #Wait Until Element Is Visible    ${EDITCONTACT}    10
    #Click Button    ${EDITCONTACT}
    Wait Until Element Is Visible    ${EDITMODULE}    10
    Log List    ${EMAILMATCHES}
    :FOR    ${ValidEmails}    IN    @{EMAILMATCHES}
    \    Input Text    ${EDITMODULE}/descendant::input[contains(@ng-model, 'email')]    ${ValidEmails}
    \    Wait Until Element Is Visible    ${EDITMODULE}/descendant::button[contains(text(), 'UPDATE')]    10
    \    Click Button    ${EDITMODULE}/descendant::button[contains(text(), 'UPDATE')]
    \    Wait Until Element Is Visible    ${DISPLAYMODULE}
    \    Wait Until Element Is Visible    ${DISPLAYMODULE}/descendant::i[contains(@class, 'mail')]/following::*[1]
    \    ${DisplayedEmail}    Get Text    ${DISPLAYMODULE}/descendant::i[contains(@class, 'mail')]/following::*[1]
    \    Run Keyword And Continue On Failure    Should Be True    '${ValidEmails}' == '${DisplayedEmail}'
    \    Wait Until Element Is Visible    ${EDITCONTACT}    10
    \    Click Button    ${EDITCONTACT}
    Wait Until Element Is Visible    ${EDITMODULE}/descendant::button[contains(text(), 'UPDATE')]
    Click Button    ${EDITMODULE}/descendant::button[contains(text(), 'UPDATE')]
    Wait Until Element Is Not Visible    ${EDITMODULE}
    Click Element    ${EDITCONTACT}

Phone Field Validation for Updating a contact
    #Wait Until Element Is Visible    ${EDITCONTACT}    10
    #Click Button    ${EDITCONTACT}
    Wait Until Element Is Visible    ${EDITMODULE}    10
    Log List    ${MATCHES}
    :FOR    ${ValidNumbers}    IN    @{MATCHES}
    \    Input Text    ${EDITMODULE}/descendant::input[contains(@ng-model, 'phone')]    ${ValidNumbers}
    \    Wait Until Element Is Visible    ${EDITMODULE}/descendant::button[contains(text(), 'UPDATE')]    10
    \    Click Button    ${EDITMODULE}/descendant::button[contains(text(), 'UPDATE')]
    \    Wait Until Element Is Visible    ${DISPLAYMODULE}
    \    Wait Until Element Is Visible    ${DISPLAYMODULE}/descendant::i[contains(@class, 'call')]/following::*[1]
    \    ${DisplayedNumber}    Get Text    ${DISPLAYMODULE}/descendant::i[contains(@class, 'call')]/following::*[1]
    \    Run Keyword And Continue On Failure    Should Be True    '(123) 456-7890' == '${DisplayedNumber}'
    \    Wait Until Element Is Visible    ${EDITCONTACT}    10
    \    Click Button    ${EDITCONTACT}
    Wait Until Element Is Visible    ${EDITMODULE}/descendant::button[contains(text(), 'UPDATE')]
    Click Button    ${EDITMODULE}/descendant::button[contains(text(), 'UPDATE')]
    Run Keyword and Ignore Error    Wait Until Element Is Not Visible    ${EDITMODULE}
    Click Element    ${EDITCONTACT}

Prettify JSON
    [Arguments]    ${RawJSON}
    ${j1}    Convert To String    ${RawJSON}
    ${j2}    Replace String    ${j1}    '    "
    ${j3}    Replace String Using Regexp    ${j2}    (u")    "
    ${j4}    Replace String Using Regexp    ${j3}    (L,)    ,
    ${json}    To Json    ${j4}    pretty_print=True
    Set Global Variable    ${JSON}    ${json}

Get New Entry ID
    [Arguments]    ${json}    ${name}
    ${id1}    Fetch From Right    ${json}    "id": "
    ${id2}    Fetch From Left    ${id1}    ",
    Set To Dictionary    ${ID}    ${name}    ${id2}
    Log Dictionary    ${ID}
    Set Global Variable    ${ID}