#/(\d{1,2}).*?\b([a-z\d]+'?s?)[\?\.\!]?$/i # Complex ask player for card regular expression
#/\D*(\d).*([2-9]|10|[JQKA])/ # Simple "ask [player] for [card]"-only regular expresssion

require 'socket'

class GoFishPlayer

  attr_reader :hand, :hand_sizes, :player_number

  def initialize
    @my_turn = false
    @hand_sizes = []
  end

  def receive_from_server
    server_data = @socket.gets
    server_data = JSON.load(server_data)
    
    @player_number = server_data['player_number'] if server_data.include?('player_number')
    @hand = server_data['hand'] if server_data.include?('hand')
    @hand_sizes = server_data['hand_sizes'] if server_data.include?('hand_sizes')
    if server_data['turn'] && @player_number == server_data['turn']
      @my_turn = true
    else
      @my_turn = false
    end
  end

  def send_user_input(input)
    card_request = parse(input)
    
    return "What's that supposed to mean?" unless card_request
    return "It's not your turn" unless @my_turn
    return "That player doesn't exist" if card_request[:opponent] > @hand_sizes.count || card_request[:opponent] <= 0
    return "You don't have any cards of that rank" if (@hand.cards.select { |card| card.rank == card_request[:card] }).empty?
    
    @socket.puts(card_request.to_json)
  end

  def parse(string)
    if match = string.match(/(\d{1,2}).*?\b([a-z\d]+'?s?)[\?\.\!]?$/i) # Find the opponent and card
      opponent = match[1].to_i
      card = match[2].upcase

      card_name = card.match(/([2-9]|10|[JQKA])/)[1] # Get card name

      {opponent: opponent, card: card_name}
    end
  end

  def connect(host, port=51528)
    @socket = TCPSocket.new(host, port)
  end
end