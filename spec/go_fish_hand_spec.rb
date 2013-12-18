require 'spec_helper'

describe GoFishHand do
  it "can be serialized and deserialized with JSON" do
    hand = GoFishHand.new([PlayingCard.new('A', 'S'), PlayingCard.new('J', 'D')])
    hand_json = hand.to_json
    hand2 = JSON.load(hand_json)

    expected_json = '{"json_class":"GoFishHand","cards":[{"json_class":"PlayingCard","rank":"A","suit":"S"},{"json_class":"PlayingCard","rank":"J","suit":"D"}]}'
    
    expect(hand_json).to eq(expected_json)
    expect(hand2).to be_an_instance_of(GoFishHand)
    expect(hand2.number_of_cards).to eq(2)
  end
end