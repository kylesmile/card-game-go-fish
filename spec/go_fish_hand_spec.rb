require 'spec_helper'

describe GoFishHand do
  it "can be serialized and deserialized with JSON" do
    hand = GoFishHand.new([PlayingCard.new('A', 'S'), PlayingCard.new('J', 'D')])
    hand_json = hand.to_json
    parsed_hand = JSON.parse(hand_json)
    hand2 = GoFishHand.json_create(parsed_hand)

    expected_json = %q({"json_class":"GoFishHand","data":"[{\"json_class\":\"PlayingCard\",\"data\":[\"A\",\"S\"]},{\"json_class\":\"PlayingCard\",\"data\":[\"J\",\"D\"]}]"})
    expected_parse = {"json_class" => "GoFishHand", 'data' => %q([{"json_class":"PlayingCard","data":["A","S"]},{"json_class":"PlayingCard","data":["J","D"]}])}

    expect(hand_json).to eq(expected_json)
    expect(parsed_hand).to eq(expected_parse)
    expect(hand2).to be_an_instance_of(GoFishHand)
    expect(hand2.number_of_cards).to eq(2)
  end
end