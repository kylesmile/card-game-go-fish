require 'spec_helper'

describe GoFishHand do
  it "can be serialized and deserialized" do
    hand = GoFishHand.new([PlayingCard.new('A', 'S'), PlayingCard.new('J', 'D')])
    hand_json = hand.to_json
    hand2 = JSON.load(hand_json)

    expected_json = '{"json_class":"GoFishHand","cards":[{"json_class":"PlayingCard","rank":"J","suit":"D"},{"json_class":"PlayingCard","rank":"A","suit":"S"}]}'
    
    expect(hand_json).to eq(expected_json)
    expect(hand2).to be_an_instance_of(GoFishHand)
    expect(hand2.number_of_cards).to eq(2)
  end
  
  it "can be printed as ascii art" do
    # A refactoring of what you have in CardDeck.initialize so you could use it here would be nice
    hand = GoFishHand.new([PlayingCard.new('A', 'S'),
                           PlayingCard.new('J', 'D'),
                           PlayingCard.new('Q', 'H'),
                           PlayingCard.new('J', 'S'),
                           PlayingCard.new('9', 'C'),
                           PlayingCard.new('J', 'H'),
                           PlayingCard.new('10', 'D'),
                           PlayingCard.new('7', 'H')])
    
    
    pretty = hand.pretty_cards
    
    # HMMM... Could you test a single card first in more detail?
    expect(pretty.lines.count).to eq(10)
  end
end
