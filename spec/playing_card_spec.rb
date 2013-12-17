require 'spec_helper'

describe PlayingCard do
  describe '#to_s' do
    it "represents a card as a string" do
      card1 = PlayingCard.new('A')
      card2 = PlayingCard.new('J', 'D')

      expect(card1.to_s).to eq 'Ace of Clubs'
      expect(card2.to_s).to eq 'Jack of Diamonds'
    end
  end

  it "can be serialized and deserialized in JSON" do
    card = PlayingCard.new('A', 'S')
    card_json = card.to_json
    parsed_card = JSON.parse(card_json)
    card2 = PlayingCard.json_create(parsed_card)

    expect(card_json).to eq(%q({"json_class":"PlayingCard","data":["A","S"]}))
    expect(parsed_card).to eq({"json_class" => "PlayingCard", "data" => ["A", "S"]})
    expect(card2).to be_an_instance_of(PlayingCard)
  end
end