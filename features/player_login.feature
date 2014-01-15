Feature: Player login
  As the developer
  In order to identify players
  I want it to have a good login process
  
  Scenario: Initial log in
    Given a user visiting the site
    And being prompted to log in
    When he inputs a valid username
    Then he should be redirected to a new game
    And have a cookie set with his username
  
  Scenario: Invalid log in
    Given a user visiting the site
    When he inputs an invalid username
    Then he should be prompted to pick a different name