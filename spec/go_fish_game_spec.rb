require 'spec_helper'

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

        @game.setup_game([hand1, hand2], CardDeck.new(['JD','3H','4C','8S','9D','10D','7H']))

        result = @game.take_turn(2, 'A')

        expect(result.turn).to eq(1)
        expect(result.wanted).to eq('A')
        expect(result.got).to eq(true)
        expect(result.amount).to eq(2)
        expect(result.from).to eq(2)
        expect(result.source).to eq("Player 2")
        expect(result.new_books).to eq(0)
        expect(@game.hand(1).cards.count).to eq(3)
        expect(@game.hand(2).cards.count).to eq(7)
        expect(@game.turn).to eq(1)
      end
    end

    context "Top card in deck is what player wants" do
      it "says player1 got 1 card he wanted from the pond" do
        hand1 = GoFishHand.new([PlayingCard.new('7', 'S')])
        hand2 = GoFishHand.new([PlayingCard.new('J', 'H')])

        @game.setup_game([hand1, hand2], CardDeck.new(['7D']))

        result = @game.take_turn(2, '7')
        
        expect(result.turn).to eq(1)
        expect(result.wanted).to eq('7')
        expect(result.got).to eq(true)
        expect(result.amount).to eq(1)
        expect(result.from).to eq(2)
        expect(result.source).to eq("Pond")
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

        @game.setup_game([hand1, hand2], CardDeck.new(['2H']))

        result = @game.take_turn(2, '4')

        expect(result.turn).to eq(1)
        expect(result.wanted).to eq('4')
        expect(result.got).to eq(false)
        expect(result.amount).to eq(1)
        expect(result.from).to eq(2)
        expect(result.source).to eq("Pond")
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

        @game.setup_game([hand1, hand2], CardDeck.new(['JD','3H','4C','8S','9D','10D','7H','JS','3D','4H','8C','9H','10C','7S']))

        result = @game.take_turn(2, 'A')

        expect(result.turn).to eq(1)
        expect(result.wanted).to eq('A')
        expect(result.got).to eq(true)
        expect(result.amount).to eq(1)
        expect(result.from).to eq(2)
        expect(result.source).to eq("Player 2")
        expect(result.new_books).to eq(1)
        expect(@game.hand(1).cards.count).to eq(7)
        expect(@game.hand(2).cards.count).to eq(7)
        expect(@game.hand(1).books).to eq(1)
        expect(@game.turn).to eq(1)
      end
    end
    
    it "properly determines the current turn" do
      hand1 = GoFishHand.new([PlayingCard.new('A', 'S')])
      hand2 = GoFishHand.new([PlayingCard.new('J', 'D')])
      
      @game.setup_game([hand1, hand2], CardDeck.new(['QH','7S']))
      
      expect(@game.turn).to eq(1)
      
      @game.take_turn(2, 'A')
      expect(@game.turn).to eq(2)
      
      @game.take_turn(1, 'J')
      expect(@game.turn).to eq(1)
    end
    
    it "gives players more cards when they run out" do
      hand1 = GoFishHand.new([PlayingCard.new('A', 'S')])
      hand2 = GoFishHand.new([PlayingCard.new('A', 'D'), PlayingCard.new('A', 'C'), PlayingCard.new('A', 'H')])
      
      @game.setup_game([hand1, hand2], CardDeck.new(['JD','3H','4C','8S','9D','10D','7H','JS','3D','4H','8C','9H','10C','7S']))
      @game.take_turn(2, 'A')
      
      expect(hand1.number_of_cards).to eq(7)
      expect(hand2.number_of_cards).to eq(7)
    end
    
    context "there are very few cards left in the deck" do
      before do
        @deck = CardDeck.new(['AS', 'JD'])
      end
      
      it "gives players as many cards as it can when they run out" do
        hand1 = GoFishHand.new([PlayingCard.new('A', 'H')])
        hand2 = GoFishHand.new([PlayingCard.new('A', 'D')])
        
        @game.setup_game([hand1, hand2], @deck)
        @game.take_turn(2, 'A')
        expect(hand1.cards.size).to eq(2)
        expect(hand2.cards.size).to eq(2)
      end
      
      it "skips players who can't get any cards" do
        game = GoFishGame.new(3)
        hand1 = GoFishHand.new([PlayingCard.new('A', 'H'), PlayingCard.new('A', 'C')])
        hand2 = GoFishHand.new([PlayingCard.new('A', 'D')])
        hand3 = GoFishHand.new([PlayingCard.new('J', 'C'), PlayingCard.new('J', 'H'), PlayingCard.new('J', 'S')])
        
        game.setup_game([hand1,hand2,hand3], @deck)
        
        game.take_turn(2, 'A')
        expect(game.turn).to eq(1)
        
        game.take_turn(2, 'A')
        expect(game.turn).to eq(2)
        
        game.take_turn(3, 'J')
        expect(game.turn).to eq(0)
      end
    end
  end
end