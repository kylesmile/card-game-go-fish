require 'spec_helper'

describe GoFishRoundResult do
  before do
    @round_result = GoFishRoundResult.new
    @round_result.turn = 1
    @round_result.wanted = 'A'
    @round_result.got = true
    @round_result.amount = 2
    @round_result.from = 2
    @round_result.source = "Player 2"
    @round_result.new_books = 0
  end

  it "can be serialized and deserialized" do
    round_result_json = @round_result.to_json
    round_result2 = JSON.load(round_result_json)
    
    expect(round_result2.turn).to eq(1)
    expect(round_result2.wanted).to eq('A')
    expect(round_result2.got).to eq(true)
    expect(round_result2.amount).to eq(2)
    expect(round_result2.from).to eq(2)
    expect(round_result2.source).to eq("Player 2")
    expect(round_result2.new_books).to eq(0)
  end  
  
  it "can be represented as a string" do
    expect(@round_result.to_s).to eq("Player 1 asked player 2 for A's. He got 2 cards that he wanted, and 0 books.")
    
    round_result2 = GoFishRoundResult.new
    round_result2.turn = 2
    round_result2.wanted = 'J'
    round_result2.got = false
    round_result2.amount = 1
    round_result2.from = 1
    round_result2.source = "Pond"
    round_result2.new_books = 0
    
    expect(round_result2.to_s).to eq("Player 2 asked player 1 for J's. He got 1 card that he didn't want from the pond, and 0 books.")
  end
end