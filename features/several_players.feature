Feature: Several logins
  As the sole developer on this project
  In order to let people play Go Fish with each other
  I want multiple people to be able to log in
  
  Scenario: Two people try to use the same name
    Given one player logged in as Bob
    When a second player attempts to log in as Bob
    Then the second player should have to pick a different name
  
  Scenario: Two people log in with different names
    Given one player logged in as Bob
    When a second player logs in with a different name
    Then the second player should be logged in