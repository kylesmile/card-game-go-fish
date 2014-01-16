require 'spec_helper'

describe GoFishGameStatus do
  before do
    @game_status = GoFishGameStatus.new(2)
  end
  
  it "passes messages it doesn't understand to the game" do
    expect(@game_status).to respond_to(:hand)
    expect(@game_status).to respond_to(:books)
    expect(@game_status.take_turn(2, 'A')).to be_a(GoFishRoundResult)
  end
  
  it "knows the number of open slots for a game" do
    expect { @game_status.hand(1) }.not_to raise_error
    expect(@game_status.game).not_to be_nil
    expect(@game_status.open_slots).to eq(2)
  end
  
  it "can connect players to a game" do
    @game_status.add_player("Bob")
    expect(@game_status.open_slots).to eq(1)
    
    @game_status.add_player("George")
    expect(@game_status.open_slots).to eq(0)
    
    expect(@game_status.players).to eq(["Bob", "George"])
  end
end