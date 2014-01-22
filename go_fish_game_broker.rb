require_relative './go_fish_game_status'

class GoFishGameBroker  
  def initialize
    @games = {}
    @open_game = nil
  end
  
  def game_count
    @games.count
  end
  
  def game(id)
    @games[id]
  end
  
  def associate_player(name)
    if @open_game.nil? || @open_game.open_slots == 0
      @open_game = GoFishGameStatus.new(2)
      @games[@open_game.object_id.to_s] = @open_game
    end
    @open_game.add_player(name)
    return @open_game.object_id.to_s
  end
end