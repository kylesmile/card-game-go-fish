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

  def to_json(*arguments)
    {
      'json_class' => self.class.name,
      'data' => @cards.to_json
    }.to_json(*arguments)
  end

  def self.json_create(object_data)
    data = JSON.parse(object_data['data'])
    cards = data.map do |datum|
      PlayingCard.json_create(datum)
    end
    new(cards)
  end
end