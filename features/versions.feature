@javascript
Feature: Versions
  In order to find out what changed
  As a user
  I need to be able to see previous versions of a script

  Background:
    Given I'm logged in

  Scenario: Load latest version of the script
    Given the api method "multiple_versions" with 3 versions
    When I view the versions for "Simple Site - multiple_versions"
    Then I see the script '"script change 2"'

  Scenario: Load previous version of the script
    Given the api method "multiple_versions" with 3 versions
    When I view the versions for "Simple Site - multiple_versions"
    And I select the version "1: change 1"
    Then I see the script '"script change 1"'

  Scenario: Compare to a previous version of the script
    Given the api method "multiple_versions" with 3 versions
    When I view the versions for "Simple Site - multiple_versions"
    And I select the comparison "1: change 1"
    Then I see the diff '"script change <del class=\"differ\">2</del><ins class=\"differ\">1</ins>"'

  Scenario: Restore an old version of the script
    Given the api method "multiple_versions" with 3 versions
    When I restore version "1: change 1" for "Simple Site - multiple_versions"
    And I go to the api method "Simple Site - multiple_versions"
    Then I see '"script change 1"' in the editor
