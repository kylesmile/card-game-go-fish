Feature: Multiple games
  As me
  In order to let more than two people play
  I want the server to handle several games
  
  @javascript
  Scenario: Second game
    Given two players connected in the first game
    When two other players connect
    Then the first two players should be in one game
    And the second two players should be in a different game