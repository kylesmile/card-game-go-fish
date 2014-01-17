Feature: Playing a game
  As me
  In order to let player play a game
  I want everything to work
  
  Scenario: Taking a turn
    Given two players connected
    When one asks for cards
    Then both should see the results
    And both should see whose turn it is