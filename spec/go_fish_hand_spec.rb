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
    hand = GoFishHand.new([PlayingCard.new('A', 'S'),
                           PlayingCard.new('J', 'D'),
                           PlayingCard.new('Q', 'H'),
                           PlayingCard.new('J', 'S'),
                           PlayingCard.new('9', 'C'),
                           PlayingCard.new('J', 'H'),
                           PlayingCard.new('10', 'D'),
                           PlayingCard.new('7', 'H')])
    
    
    pretty = hand.pretty_cards
    
    expect(pretty.lines.count).to eq(10)
  end
  
  it "keeps track of which books it gets" do
    hand = GoFishHand.new([PlayingCard.new('A', 'S'),
                           PlayingCard.new('A', 'H'),
                           PlayingCard.new('A', 'D'),
                           PlayingCard.new('A', 'C'),
                           PlayingCard.new('J', 'D')])
    expect(hand.books.count).to eq 1
    expect(hand.books).to eq ["A"]
  end
end