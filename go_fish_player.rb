#/(\d{1,2}).*?\b([a-z\d]+'?s?)[\?\.\!]?$/i # Complex ask player for card regular expression
#/\D*(\d).*([2-9]|10|[JQKA])/ # Simple "ask [player] for [card]"-only regular expresssion

require 'socket'

class GoFishPlayer
  COMMAND_MATCH = /(\d{1,2}).*?\b([a-z\d]+'?s?)[\?\.\!]?$/i # Player number and card

  attr_reader :hand, :card_counts

  def initialize
    @my_turn = false
    @card_counts = []
  end

  def receive_from_server
    server_data = @socket.gets
    server_data = JSON.load(server_data)
    @hand = server_data['hand'] if server_data.include?('hand')
    @card_counts = server_data['card_counts'] if server_data.include?('card_counts')
    if server_data['turn'] && server_data['you_are'] == server_data['turn']
      @my_turn = true
    else
      @my_turn = false
    end
  end

  def send_user_input(input)
    parsed_input = parse(input)
    
    return "What's that supposed to mean?" unless parsed_input
    return "It's not your turn" unless @my_turn
    return "That player doesn't exist" if parsed_input[:opponent] > @card_counts.count || parsed_input[:opponent] <= 0
    return "You don't have any cards of that rank" if (@hand.cards.select { |card| card.rank == parsed_input[:card] }).empty?
    
    @socket.puts(parsed_input.to_json)
  end

  def parse(string)
    if match = string.match(COMMAND_MATCH)
      opponent = match[1].to_i
      card = match[2].upcase

      card_name = card.match(/([2-9]|10|[JQKA])/)[0] # Get card name

      {opponent: opponent, card: card_name}
    end
  end

  def connect(host='kyle-laptop.local', port=51528)
    @socket = TCPSocket.new(host, port)
  end
end