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
end