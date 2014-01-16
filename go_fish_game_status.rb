require_relative './go_fish_game'

class GoFishGameStatus
  attr_reader :game, :open_slots, :players
  
  def initialize(player_count)
    @game = GoFishGame.new(player_count)
    @game.setup_game
    @open_slots = player_count
    @players = []
  end
  
  def add_player(name)
    @players.push(name)
    @open_slots -= 1
  end
  
  def method_missing(method, *args, &block)
    @game.send(method, *args, &block)
  end
  
  def respond_to?(method)
    @game.respond_to?(method) || super
  end
end