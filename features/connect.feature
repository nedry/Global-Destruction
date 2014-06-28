Feature: Connect with the server

  Just working out the basic infrastructure for testing this thing.
  We don't know what to test yet, because we don't know what it
  actually does.

  Scenario: Connect
    Given I start the server
    Given I connect

  Scenario: Connect agin
    Given I start the server
    Given I connect
