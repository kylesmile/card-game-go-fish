class GoFishHand
  attr_reader :books, :cards
  def initialize(cards)
    @cards = cards
    @books = 0
  end

  def number_of_cards
    @cards.count
  end

  def got_any(card)
    have = @cards.select { |c| c.value == card.value }
    @cards.delete_if { |c| c.value == card.value }
    have
  end

  def take_cards(cards)
    @cards.push(*cards)

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