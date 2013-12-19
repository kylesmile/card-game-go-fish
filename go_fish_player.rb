#/(\d{1,2}).*?\b([a-z\d]+'?s?)[\?\.\!]?$/i # Complex ask player for card regular expression
#/\D*(\d).*([2-9]|10|[JQKA])/ # Simple "ask [player] for [card]"-only regular expresssion

require 'socket'
require_relative './playing_card'
require_relative './go_fish_hand'
require_relative './go_fish_round_result'

class GoFishPlayer

  attr_reader :player_number, :hand, :hand_sizes

  def initialize
    @my_turn = false
  end

  def receive_from_server
    server_data = @socket.gets
    server_data = JSON.load(server_data)

    @player_number = server_data['player_number'] if server_data.include?('player_number')
    @hand = server_data['hand'] if server_data.include?('hand')
    @hand_sizes = server_data['hand_sizes'] if server_data.include?('hand_sizes')
    if server_data.include?('turn')
      if @player_number == server_data['turn']
        @my_turn = true
      else
        @my_turn = false
      end
    end
    
    return server_data
  end

  def send_user_input(input)
    card_request = parse(input)
    
    return "What's that supposed to mean?" unless card_request
    return "It's not your turn" unless @my_turn
    return "You can't ask yourself for cards!" if card_request[:opponent] == @player_number
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

  def connect(host, port = 51528)
    @socket = TCPSocket.new(host, port)
  end
end

if __FILE__ == $0
  player = GoFishPlayer.new
  print "What host? Press [enter] for default "
  host = gets.chomp
  host = 'kyle-laptop.local' if host.empty?
  print "What port? Press [enter] for default "
  port = gets.to_i
  port = 51528 if port == 0
  player.connect(host, port)
  
  puts "To ask a player for cards, use anything from:"
  puts "Player 1, do you have any aces?"
  puts "to:"
  puts "1 A"
  
  puts "Waiting for more players..."
  
  Thread.new do
    loop do
      hash = player.receive_from_server
      
      puts "You are player #{hash['player_number']}" if hash.include?('player_number')
      puts "It's player #{hash['turn']}'s turn" if hash.include?('turn')
      
      if hash.include?('hand_sizes')
        hash['hand_sizes'].each_with_index do |size, index|
          which = index + 1
          puts "Player #{which} has #{hash['books'][index]} books and #{size} cards"
        end
      end
      
      if hash.include?('hand')
        puts "Your cards:"
        puts hash['hand'].pretty_cards
      end
      
      winner = hash['winner'] if hash.include?('winner')
      
      puts hash['round_result'].to_s if hash.include?('round_result')
      
      if winner
        puts "Player #{winner} wins!"
        puts "Thanks for playing!"
        Thread.main.kill
      end
    end
  end
  
  loop do
    bad_input_message = player.send_user_input(gets)
    puts bad_input_message if bad_input_message
  end
end