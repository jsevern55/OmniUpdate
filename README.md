# Test automation project for OmniUpdate
This repository contains a project for the QA Automation Engineer test.

Please contact me if there are any questions - jsevern55@outlook.com

## Requirements:
* Windows 10
* Chrome 67+
* [Python 2.7.12](https://www.python.org/ftp/python/2.7.15/python-2.7.15.amd64.msi) (Install to `C:\` for the sake of simplicity)
* [Node.js](https://nodejs.org/en/download/current/)
* [Chromdriver.exe](https://chromedriver.storage.googleapis.com/2.40/chromedriver_win32.zip) (copy to `C:\Python27\Scripts`)
* [Git for Windows](https://git-scm.com/download/win)

## Prerequisites & Setup:
#### Environment Variables: 
Ensure that the following directories are added to the System variable "Path" (if they are not already added). **NOTE:** Modifying the system variables will require a computer restart.
  * C:\Python27
  * C:\Python27\Scripts
  * C:\Python27\site-packages
#### Install the following packages using `pip install [package]`:
  * `robot`
  * `selenium`
  * `robotframework`
  * `robotframework-seleniumlibrary`
  * `requests`
  * `robotframework-requests`
  
#### Cloning this repository:
  * Open a new terminal
  * Change directory to C:\ (`cd \`)
  * Run `git clone https://github.com/jsevern55/OmniUpdate.git`

## Executing test cases:
  * Change directory to the local repository `cd OmniUpdate`
  * Execute the test case `robot -d logs -T tests\[name].robot`
  * Logs can be found in `C:\OmniUpdate\logs`
    * `log-[timestamp].html` provides a detailed report of the executed test case. Screenshots (if any) will be rendered in the log.
   
## Available test cases
  * **OmniUpdate_Address_book_API_test.robot** (Executes all available address book API commands)
  * **OmniUpdate_Address_book_GUI_Contact_Flow_test.robot** (End-to-End test of the create, update, delete contact flow)
  * **OmniUpdate_Address_book_GUI_Filter_Contacts_test.robot** (Smoke test of Filtering contacts by First name, or Last name, or Email)
  * **OmniUpdate_Address_book_GUI_Sort_Contacts_test.robot** (Smoke test of Sorting contacts by First name, Last name, and Email)
  * **OmniUpdate_Address_book_GUI_View_Contact_test.robot** (Clicks on a contact, and verifies the contact display view appears)
  * **OmniUpdate_Address_book_Integration_test.robot** (All tests mentioned above)
