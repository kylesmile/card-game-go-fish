Feature: unable to log in twice
  As someone who knows people who like to break things
  In order to keep people from breaking things
  I want to prevent people from logging in when they are already logged in
  
  Scenario: Player attempts double log in
    Given a player is already logged in
    When the player tries to visit the log in page
    Then he is redirected to another page