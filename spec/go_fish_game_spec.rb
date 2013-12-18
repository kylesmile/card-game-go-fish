require 'spec_helper'

class GoFishGame
  attr_reader :deck
end

class CardDeck
  def set_top_card(card)
    @cards.push(card)
  end
end

describe GoFishGame do

  before do
    @game = GoFishGame.new(2)
  end

  it "deals cards to players" do
    @game.setup_game
    expect(@game.hand(1).number_of_cards).to eq(7)

    game = GoFishGame.new(4)
    game.setup_game
    expect(game.hand(1).number_of_cards).to eq(7)

    game = GoFishGame.new(5)
    game.setup_game
    expect(game.hand(1).number_of_cards).to eq(5)
  end

  it "tells what cards players have" do
    @game.setup_game
    expect(@game.hand(1).cards[0]).to be_an_instance_of(PlayingCard)
  end

  it "tells whose turn it is" do
    expect(@game.turn).to eq(1)
  end

  describe '#take_turn' do
    it "returns an instance of GoFishRoundResult" do
      @game.setup_game
      result = @game.take_turn(2,'A')
      expect(result).to be_an_instance_of(GoFishRoundResult)
    end

    context "Player2 has what player1 wants" do
      it "says player2 gave 2 cards to player1" do
        hand1 = GoFishHand.new([PlayingCard.new('A', 'S')])
        hand2 = GoFishHand.new([PlayingCard.new('A', 'H'), PlayingCard.new('A', 'D')])

        @game.setup_game([hand1, hand2])

        result = @game.take_turn(2, 'A')

        expect(result.wanted).to eq('A')
        expect(result.got).to eq(true)
        expect(result.amount).to eq(2)
        expect(result.from).to eq "Player 2"
        expect(result.new_books).to eq(0)
        expect(@game.hand(1).cards.count).to eq(3)
        expect(@game.hand(2).cards.count).to eq(0)
        expect(@game.turn).to eq(1)
      end
    end

    context "Top card in deck is what player wants" do
      it "says player1 got 1 card he wanted from the pond" do
        hand1 = GoFishHand.new([PlayingCard.new('7', 'S')])
        hand2 = GoFishHand.new([PlayingCard.new('J', 'H')])

        @game.setup_game([hand1, hand2])
        @game.deck.set_top_card(PlayingCard.new('7', 'D'))

        result = @game.take_turn(2, '7')

        expect(result.wanted).to eq('7')
        expect(result.got).to eq(true)
        expect(result.amount).to eq(1)
        expect(result.from).to eq "Pond"
        expect(result.new_books).to eq(0)
        expect(@game.hand(1).cards.count).to eq(2)
        expect(@game.hand(2).cards.count).to eq(1)
        expect(@game.turn).to eq(1)
      end
    end

    context "Top card in deck is not what player wants" do
      it "says player1 got 1 card he didn't want" do
        hand1 = GoFishHand.new([PlayingCard.new('4', 'S')])
        hand2 = GoFishHand.new([PlayingCard.new('J', 'D')])

        @game.setup_game([hand1, hand2])
        @game.deck.set_top_card(PlayingCard.new('2', 'H'))

        result = @game.take_turn(2, '4')

        expect(result.wanted).to eq('4')
        expect(result.got).to eq(false)
        expect(result.amount).to eq(1)
        expect(result.from).to eq "Pond"
        expect(result.new_books).to eq(0)
        expect(@game.hand(1).cards.count).to eq(2)
        expect(@game.hand(2).cards.count).to eq(1)
        expect(@game.turn).to eq(2)
      end
    end

    context "Player 2 has what player 1 needs for a book" do
      it "says player 1 got a book" do
        hand1 = GoFishHand.new([PlayingCard.new('A', 'S'), PlayingCard.new('A', 'D'), PlayingCard.new('A', 'C')])
        hand2 = GoFishHand.new([PlayingCard.new('A', 'H')])

        @game.setup_game([hand1, hand2])

        result = @game.take_turn(2, 'A')

        expect(result.wanted).to eq('A')
        expect(result.got).to eq(true)
        expect(result.amount).to eq(1)
        expect(result.from).to eq "Player 2"
        expect(result.new_books).to eq(1)
        expect(@game.hand(1).cards.count).to eq(0)
        expect(@game.hand(2).cards.count).to eq(0)
        expect(@game.hand(1).books).to eq(1)
        expect(@game.turn).to eq(1)
      end
    end
  end
end