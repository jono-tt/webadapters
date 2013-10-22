@javascript
Feature: Encoding
  In order to use non-ascii characters
  As an user
  I need web adapter to correctly encode and decode characters

  Background:
    Given I'm logged in

  Scenario: Send a £
    Given the "encoding script" site exists
    When I run the script for "Simple Site - encoding_script"
    Then I see the result '"Testing 6 symbols, including £ and ł: true"'
