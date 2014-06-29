Feature: Help

  As a player I want to see the help page because I don't remember
  what the commands are.

  Scenario: Logged in
    Given I am logged in
    When I ask for help
    Then I should see help
