Feature: Script Errors
  In order to create working scripts
  As an admin user
  I need to know if my script breaks

  Background:
    Given I'm logged in

  @javascript
  Scenario: Report a syntax error
    Given the "syntax error" site exists
    When I run the script for "Simple Site - syntax_error"
    Then I see the error message 'Syntax error on line 1'

  @javascript
  Scenario: Report a semantic error
    Given the "semantic error" site exists
    When I run the script for "Simple Site - semantic_error"
    Then I see the error message 'NameError: undefined local variable or method `blah''

  @javascript
  Scenario: Report a missing result
    Given the "missing result" site exists
    When I run the script for "Simple Site - missing_result"
    Then I see the warning message 'The script produced no output. Did you forget to add 'result' to the end?'

  @javascript
  Scenario: See Debug information
    Given the "debug info" site exists
    When I run the script for "Simple Site - debug_info"
    Then I see debug information "debug information"
