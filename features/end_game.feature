Feature: End of game
  
  As me
  In order to finish the game
  I want a nice end of game screen
  
  @javascrip
  Scenario: Ending the game
    Given the game is one move away from the end
    And two players are connected
    When a player makes the last move
    Then all players should be redirected to an end game screen
    And the winner should be announced