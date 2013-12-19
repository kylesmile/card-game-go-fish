class GoFishHand
  attr_reader :books, :cards
  def initialize(cards)
    @cards = cards
    @books = 0
    sort_cards
    check_for_books
  end

  def number_of_cards
    @cards.count
  end

  def got_any(card)
    have = @cards.select { |c| c.value == card.value }
    @cards.delete_if { |c| c.value == card.value }
    have
  end
  
  def sort_cards
    cards.sort! { |a,b| a.value <=> b.value}
  end

  def check_for_books
    new_books = 0
    full_sets = Array.new(13,0)
    @cards.each { |card| full_sets[card.value] += 1 }

    full_sets.each_with_index do |amount, i|
      if amount == 4
        new_books += 1
        @cards.delete_if { |c| c.value == i}
      end
    end

    @books += new_books
    new_books
  end

  def take_cards(cards)
    @cards.push(*cards)
    @cards.sort! { |a,b| a.value <=> b.value}
    check_for_books
  end
  
  CardTemplate = [' _____  ',
                  '|RR   | ',
                  '|  S  | ',
                  '|   RR| ',
                  ' -----  ']
  PRETTY_SUITS = {'C' => '♣', 'H' => '♥', 'S' => '♠', 'D' => '♦'}
  
  def pretty_cards
    apparent_line = 0
    pretty_cards = ['','','','','']
    @cards.each_with_index do |card, index|
      if index % 7 == 0 && index > 0
        apparent_line += 1
        pretty_cards.concat(['','','','',''])
      end
      
      rank = card.rank
      suit = card.suit
      color = card.color
      5.times do |line|
        rank_print = rank
        if rank.length == 1
          rank_print = "#{rank} " if line == 1
          rank_print = " #{rank}" if line == 3
        end
        card_line = CardTemplate[line].sub(/RR/, rank_print)
        card_line.sub!(/S/, PRETTY_SUITS[suit])
        pretty_cards[apparent_line*5 + line] << (color + card_line)
      end
    end
    pretty_cards.join("\n") + PlayingCard::BLACK
  end
  
  def as_json
    {
      'json_class' => self.class.name,
      'cards' => @cards.map { |card| card.as_json }
    }
  end

  def to_json(*arguments)
    as_json.to_json(*arguments)
  end

  def self.json_create(hash)
    self.new(hash['cards'])
  end
end