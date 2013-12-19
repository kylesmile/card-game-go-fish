class GoFishRoundResult
  attr_accessor :turn, :wanted, :got, :amount, :from, :new_books, :source
  
  def to_s
    string = "Player #{@turn} asked player #{from} for #{wanted}'s."
    string << " He got #{amount} card#{'s' unless amount == 1} that he"
    
    if got
      string << " wanted"
    else
      string << " didn't want"
    end
    
    if source == "Pond"
      string << " from the pond"
    end
    
    string << ", and #{new_books} books."
  end
  
  def as_json
    {
      'json_class' => self.class.name,
      'turn' => @turn,
      'wanted' => @wanted,
      'got' => @got,
      'amount' => @amount,
      'from' => @from,
      'source' => @source,
      'new_books' => @new_books
    }
  end

  def to_json(*arguments)
    as_json.to_json(*arguments)
  end

  def self.json_create(hash)
    new_me = self.new
    new_me.turn = hash['turn']
    new_me.wanted = hash['wanted']
    new_me.got = hash['got']
    new_me.amount = hash['amount']
    new_me.from = hash['from']
    new_me.source = hash['source']
    new_me.new_books = hash['new_books']
    return new_me
  end
end