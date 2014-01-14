require_relative './go_fish_hand'
require_relative './card_deck'
require_relative './go_fish_round_result'

class GoFishGame
  attr_reader :turn

  def initialize(player_count)
    @number_of_players = player_count
    @turn = 1
  end

  def setup_game(hands = nil, deck = nil)
    if deck
      @deck = deck
    else
      @deck = CardDeck.new
      @deck.shuffle
    end

    @hand_size = @number_of_players <= 4 ? 7 : 5

    if hands
      @hands = hands
    else
      @hands = []

      @number_of_players.times do 
        @hands << GoFishHand.new(@deck.deal(@hand_size))
      end
    end
  end

  def hand(which)
    @hands[which - 1]
  end
  
  def winner
    if @turn == 0
      books.index(books.max) + 1
    end
  end
  
  def hand_sizes
    @hands.map { |hand| hand.number_of_cards }
  end
  
  def deck_size
    @deck.number_of_cards
  end
  
  def books
    @hands.map { |hand| hand.books.count }
  end
  
  def take_turn(opponent, card)
    result = GoFishRoundResult.new
    result.turn = @turn
    result.wanted = card
    result.from = opponent
    
    wanted_card = PlayingCard.new(card)
    cards = hand(opponent).got_any(wanted_card)
    
    if cards.empty?
      cards = @deck.deal
      result.source = "Pond"
    else
      result.source = "Player #{opponent}"
    end

    result.got = (cards[0].rank == wanted_card.rank)
    
    result.amount = cards.count
    result.new_books = hand(turn).take_cards(cards)
    
    hand(turn).take_cards(@deck.deal(@hand_size)) if hand(turn).number_of_cards == 0
    hand(opponent).take_cards(@deck.deal(@hand_size)) if hand(opponent).number_of_cards == 0
    
    stop_turn = @turn - 1
    stop_turn = @number_of_players if stop_turn == 0
    begin
      @turn += 1 unless result.got && hand(@turn).number_of_cards > 0
      @turn = 1 if @turn > @number_of_players
    end until hand(@turn).number_of_cards > 0 || @turn == stop_turn

    @turn = 0 if @turn == stop_turn && hand(@turn).number_of_cards == 0

    return result
  end
end