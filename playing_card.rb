require 'json'

#/(10|[2-9]|[JQKA])\W*[of]*\W*([SDHC])\w*/i # Card name

class PlayingCard
  RANKS = %w(2 3 4 5 6 7 8 9 10 J Q K A)
  SUITS = %w(C H D S)
  RANKNAMES = %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace)
  SUITNAMES = %w(Clubs Hearts Diamonds Spades)
  def initialize(rank, suit='C')
    @rank, @suit = rank, suit
  end

  def value
    RANKS.index(@rank)
  end

  def to_s
    "#{RANKNAMES[value]} of #{(SUITNAMES[SUITS.index(@suit)])}"
  end

  def to_json(*arguments)
    {
      'json_class' => self.class.name,
      'data' => [@rank, @suit]
    }.to_json(*arguments)
  end

  def self.json_create(object_data)
    new(*object_data['data'])
  end
end