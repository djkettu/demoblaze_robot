*** Settings ***
Documentation                       Test to verify that demoblaze.com purchase flow
...                                 happy path works.
Resource                            ../Resources/demoblaze.resource
Library                             Collections
Library                             String

Test Setup                          Open Context and Page

*** Test Cases ***
Purchase a Nokia Lumia 1520
    Purchase a Product              phones  lumia