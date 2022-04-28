*** Settings ***
Documentation   To be init file for roboteering.
Resource        sadf.resource
Suite Setup     Open Context
Test Setup      Open Page

*** Test Cases ***


*** Keywords ***
Create Browser
    Start Watch
    New Browser     browser=chrome
    Log Time        New Browser