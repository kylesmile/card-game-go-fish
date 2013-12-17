require_relative './go_fish_hand'
require_relative './card_deck'
require_relative './go_fish_round_result'

class GoFishGame
  attr_reader :turn

  def initialize(player_count)
    @number_of_players = player_count
    @turn = 1
  end

  def setup_game(hands=nil)
    @deck = CardDeck.new
    @deck.shuffle

    if hands
      @hands = hands
    else
      hand_size = @number_of_players <= 4 ? 7 : 5

      @hands = []

      @number_of_players.times do 
        @hands << GoFishHand.new(@deck.deal(hand_size))
      end
    end
  end

  def hand(which)
    @hands[which - 1]
  end

  def take_turn(asked_player, card)
    result = GoFishRoundResult.new
    wanted_card = PlayingCard.new(card)
    cards = hand(asked_player).got_any(wanted_card)

    if cards.empty?
      cards = @deck.deal
      result.from = "Pond"
    else
      result.from = "Player #{asked_player}"
    end

    result.wanted = (cards[0].value == wanted_card.value)

    result.amount = cards.count
    result.new_books = hand(turn).take_cards(cards)

    @turn += 1 unless result.wanted #guess what his doesn't handle (yet)...

    result
  end
end