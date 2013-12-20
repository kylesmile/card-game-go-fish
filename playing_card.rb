require 'json'

#/(10|[2-9]|[JQKA])\W*[of]*\W*([SDHC])\w*/i # Card name

class PlayingCard
  attr_reader :rank, :suit
  
  # document here or in color what technique/standard you are using... a URL could help
  RED = "\033[0;31m"
  BLACK = "\033[0m"
  
  RANKS = %w(2 3 4 5 6 7 8 9 10 J Q K A)
  SUITS = %w(C H D S)
  RANK_NAMES = %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace)
  SUIT_NAMES = %w(Clubs Hearts Diamonds Spades)
  def initialize(rank, suit='C')
    @rank, @suit = rank, suit
  end

  def value
    RANKS.index(@rank)
  end
  
  def color
    @suit.match(/[HD]/) ? RED : BLACK
  end
  
  def to_s
    "#{RANK_NAMES[value]} of #{(SUIT_NAMES[SUITS.index(@suit)])}"
  end
  
  def as_json
    {
      'json_class' => self.class.name,
      'rank' => @rank,
      'suit' => @suit
    }
  end

  def to_json(*arguments)
    as_json.to_json(*arguments)
  end

  def self.json_create(hash)
    self.new(hash['rank'], hash['suit'])
  end
end
