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

  it "can be serialized and deserialized" do
    card = PlayingCard.new('A', 'S')
    card_json = card.to_json
    card2 = JSON.load(card_json)

    expect(card_json).to eq('{"json_class":"PlayingCard","rank":"A","suit":"S"}')
    expect(card2).to be_an_instance_of(PlayingCard)
  end
  
  it "works well in a hash" do
    card1 = PlayingCard.new('A', 'S')
    card2 = PlayingCard.new('A', 'S')
    hash = {card1 => "value"}
    expect(card1).to eq(card2)
    expect(hash[card1]).to eq("value")
    expect(hash[card2]).to eq("value")
  end
    
end