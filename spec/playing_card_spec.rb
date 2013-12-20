require 'spec_helper'

describe PlayingCard do
  describe 'creation' do
    it "accepts valid ranks and suits" do
      two_of_clubs = PlayingCard.new('2','C')
      expect(two_of_clubs.rank).to eq '2'
      expect(two_of_clubs.suit).to eq 'C'
      ace_of_hearts = PlayingCard.new('A','H')
      expect(ace_of_hearts.rank).to eq 'A'
      expect(ace_of_hearts.suit).to eq 'H'
    end

    it "accepts just a rank" do
      two = PlayingCard.new('2')
      expect(two.rank).to eq '2'
      expect(PlayingCard::SUITS).to include two.suit
    end

    it "rejects an invalid rank" do
      expect{ PlayingCard.new('1', 'C') }.to raise_exception
    end

    it "rejects an invalid suit" do
      expect{ PlayingCard.new('2', 'J') }.to raise_exception
    end
  end

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
    expect(card2.rank).to eq card.rank
    expect(card2.suit).to eq card.suit
  end
end
