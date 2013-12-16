require 'spec_helper'

describe CardDeck do
  before :each do
    @deck = CardDeck.new
  end

  it "has cards" do
    expect(@deck).to have_cards
  end

  it "deals cards" do
    expect(@deck.number_of_cards).to eq 52
    card = @deck.deal[0]
    expect(card).to be_a_kind_of PlayingCard
    expect(@deck.number_of_cards).to eq 51
  end

  it "can deal several cards at once" do
    hand = @deck.deal(26)
    expect(hand).to have(26).playing_cards

    @deck.deal(26)
    expect(@deck).not_to have_cards
  end
end