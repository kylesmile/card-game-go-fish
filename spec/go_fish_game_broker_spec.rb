require 'spec_helper'

describe GoFishGameBroker do
  before do
    @game_broker = GoFishGameBroker.new  
  end
  
  it 'creates a new game if it has none' do
    @game_broker = GoFishGameBroker.new
    expect(@game_broker.game_count).to eq(0)
    game_id = @game_broker.associate_player('Bob')
    expect(game_id).not_to be_nil
    game = @game_broker.game(game_id)
    expect(game).to be_a(GoFishGameStatus)
    expect(@game_broker.game_count).to eq(1)
    expect(game.players).to eq(['Bob'])
  end
  
  
  it 'adds more players to the same game' do
    game_id1 = @game_broker.associate_player('Bob')
    game_id2 = @game_broker.associate_player('George')
    expect(game_id1).to eq(game_id2)
    expect(@game_broker.game_count).to eq(1)
    expect(@game_broker.game(game_id1).players).to eq(['Bob', 'George'])
  end
  
  it 'creates a new game if it runs out of slots' do
    game_id1 = @game_broker.associate_player('Bob')
    game_id2 = @game_broker.associate_player('George')
    game_id3 = @game_broker.associate_player('Tom')
    game_id4 = @game_broker.associate_player('Sam')
    
    expect(game_id1).to eq(game_id2)
    expect(game_id1).not_to eq(game_id3)
    expect(game_id3).to eq(game_id4)
    expect(@game_broker.game(game_id4).players).to eq(['Tom', 'Sam'])
  end
  
  context 'game in progress' do
    before do
      @game_id = @game_broker.associate_player('Bob')
      @game_broker.associate_player('George')
    end
    
    it 'notifies those interested when someone takes a turn' do
      result = nil
      @game_broker.subscribe(@game_id, self) do |turn_result|
        result = turn_result
      end
      
      @game_broker.take_turn(@game_id, 'George', 'A')
      
      expect(result).to be_a(GoFishRoundResult)
    end
    
    it 'allows unsubscribes' do
      result = nil
      @game_broker.subscribe(@game_id, self) do |turn_result|
        result = turn_result
      end
      
      @game_broker.unsubscribe(@game_id, self)
      
      @game_broker.take_turn(@game_id, 'George', 'A')
      
      expect(result).to be_nil
    end
  end
end