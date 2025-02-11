*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${URL}                       https://www.practo.com/doctors
${SEARCH_BOX_XPATH}          //input[@data-qa-id='omni-searchbox-keyword']
${SUGGESTION_ITEM_XPATH}     (//div[contains(@class,'c-omni-suggestion-item')])[1]
${DOCTOR_LIST_XPATH}         (//h2[@data-qa-id='doctor_name'])[5]
${DOCTOR_URL_XPATH}          (//h2[@data-qa-id='doctor_name'])[5]/ancestor::a
${TODAY_SLOT_XPATH}          (//div[contains(@class,'c-day-session__slot')]/span)[1]
${TOMORROW_TAB_XPATH}        //div[contains(@class,'c-slots-header')]//i[contains(@class,'c-slots-header__next-btn')]
${FIRST_SLOT_XPATH}          (//div[contains(@class,'c-day-session__slot')]/span)[1]

*** Test Cases ***
Search Dentist And Book First Available Slot
    Open Browser  ${URL}  chrome
    Maximize Browser Window

    # Search for "Dentist"
    Wait Until Element Is Visible  ${SEARCH_BOX_XPATH}  timeout=10s
    Clear Element Text  ${SEARCH_BOX_XPATH}
    Input Text  ${SEARCH_BOX_XPATH}  Dentist
    Sleep  3s

    # Click the first suggestion
    ${SUGGESTION_COUNT} =  Get Element Count  ${SUGGESTION_ITEM_XPATH}
    Run Keyword If  ${SUGGESTION_COUNT} < 1  Fail  "No suggestions found!"
    Click Element  ${SUGGESTION_ITEM_XPATH}

    # Extract the 3rd doctor's URL
    Wait Until Element Is Visible  ${DOCTOR_URL_XPATH}  timeout=10s
    ${DOCTOR_URL} =  Get Element Attribute  ${DOCTOR_URL_XPATH}  href
    Log  "Doctor's URL: ${DOCTOR_URL}"

    Go To  ${DOCTOR_URL}

    Sleep  3s


    ${TODAY_SLOT_COUNT} =  Get Element Count  ${TODAY_SLOT_XPATH}
    Run Keyword If  ${TODAY_SLOT_COUNT} > 0  Book Slot  ${TODAY_SLOT_XPATH}  ELSE  Go To Tomorrow And Book Slot

    Sleep  10s
    Close Browser

*** Keywords ***
Book Slot
    [Arguments]  ${SLOT_XPATH}
    Wait Until Element Is Visible  ${SLOT_XPATH}  timeout=10s
    Click Element  ${SLOT_XPATH}
    Log  "Successfully booked a slot."

Go To Tomorrow And Book Slot
    Wait Until Page Contains Element  ${TOMORROW_TAB_XPATH}  timeout=20s
    Scroll Element Into View  ${TOMORROW_TAB_XPATH}
    Execute JavaScript  document.querySelector(".c-slots-header__next-btn").click()


    Sleep  3s
    Wait Until Element Is Visible  ${FIRST_SLOT_XPATH}  timeout=10s
    Click Element  ${FIRST_SLOT_XPATH}
    Log  "No slots available today. Booked a slot for tomorrow."