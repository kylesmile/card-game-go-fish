Feature: Second player
  As me
  In order to let people play Go Fish
  I want two players to be able to connect to the same game
  
  Scenario: Second player connects
    Given one player is already connected
    When the second player connects
    Then they should both be in the same game
    And they should each have the proper hands
    And only player 1 should be able to ask for cards