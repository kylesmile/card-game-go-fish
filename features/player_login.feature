Feature: Player login
  As the developer
  In order to uniquely identify players
  I want it to have a simple login process
  
  Scenario: Not logged in
    When a user visits the site for the first time
    Then he is prompted to log in
  
  Scenario: Invalid log in
    Given a user wishing to log in
    When he inputs an invalid username
    Then he should be prompted to pick a different name
  
  Scenario: Valid log in
    Given a user wishing to log in
    When he inputs a valid username
    Then he should be directed to join or create a game