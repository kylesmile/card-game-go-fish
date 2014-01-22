require_relative './go_fish_game_status'

class GoFishGameBroker
  class Subscription
    attr_reader :subscriber
    def initialize(subscriber, block)
      @subscriber = subscriber
      @block = block
    end
    
    def notify(result)
      @block.call(result)
    end
  end
  
  def initialize
    @games = {}
    @subscribers = {}
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
  
  def take_turn(game_id, opponent_name, card)
    which_game = @games[game_id]
    opponent = which_game.players.index(opponent_name) + 1
    which_game.take_turn(opponent, card)
    notify_result(game_id, which_game.last_turn)
  end
  
  def subscribe(game_id, subscriber, &block)
    @subscribers[game_id] ||= {}
    subscription = Subscription.new(subscriber, block)
    @subscribers[game_id][subscriber] = subscription
  end
  
  def unsubscribe(game_id, subscriber)
    @subscribers[game_id].delete(subscriber)
  end
  
  private
  def notify_result(game_id, result)
    subscriptions = @subscribers[game_id]
    subscriptions.each do |subscriber, subscription|
      subscription.notify(result)
    end
  end
end