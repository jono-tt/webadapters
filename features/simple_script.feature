@javascript
Feature: Simple Script
  In order to parse a simple site
  As an user
  I need to be able to create and run scripts

  Background:
    Given I'm logged in

  Scenario: Run a simple script
    Given the "simple script" site exists
    When I run the script for "Simple Site - simple_script"
    Then I see the result '"It works"'

  Scenario: Run a script with get
    Given the origin site "google.com" returns the page "google.html"
    And the "get script" site exists
    When I run the script for "Simple Site - get_script"
    Then I see the result '"Title is: Google"'

  Scenario: Run a script with post
    Given that posting to the origin site "google.com" returns the page "google.html" for data
      | email    | user@some.domain    |
      | password | top secret password |
    And the "post script" site exists
    When I run the script for "Simple Site - post_script"
    Then I see the result '"Title is: Google"'

  Scenario: Save the script
    Given the "simple script" site exists
    When I save the script for "Simple Site - simple_script"
    Then I see the result "Yay!"
    Then I see the result "Script saved"

  Scenario: Request statistics
    Given the "simple script" site exists
    When I run the script for "Simple Site - simple_script"
    Then I see stats for it