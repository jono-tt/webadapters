Feature: Debug expressions
  In order to create working scripts
  As an admin user
  I need to if debug information appears in UI

  Background:
    Given I'm logged in

  @javascript
  Scenario: See Debug information
    Given the "debug info" site exists
    When I run the script for "Simple Site - debug_info"
    Then I see debug information "debug information"