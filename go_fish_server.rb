require 'socket'
require_relative './go_fish_game'

class GoFishServer
  attr_reader :clients, :game
  
  def initialize(port=51528)
    @server = TCPServer.new(port)
    @clients = []
  end
  
  def stop
    @server.close
  end
  
  def accept_connection
    @clients << @server.accept
  end
  
  def broadcast(message)
    @clients.each do |client|
      client.puts(message)
    end
  end
  
  def narrowcast(message, to_whom) #Always pay attention to grammar...
    @clients[to_whom - 1].puts(message)
  end
  
  def send_setup_data
    @clients.each_index do |index|
      which = index + 1
      narrowcast({'player_number' => which}.to_json, which)
    end
  end
  
  def send_hand_data
    data_to_send = {'hand_sizes' => @game.hand_sizes, 'books' => @game.books, 'deck_size' => @game.deck_size}
    @clients.each_with_index do |client, index|
      which = index + 1
      data_to_send['hand'] = @game.hand(which).as_json
      narrowcast(data_to_send.to_json, which)
    end
  end
  
  def send_turn
    turn_data = {'turn' => @game.turn}
    broadcast(turn_data.to_json)
  end
  
  def winner
    @game.winner
  end
  
  def start_game(hands = nil, deck = nil)
    if @clients.count > 1
      @game = GoFishGame.new(@clients.count)
      @game.setup_game(hands, deck)
      send_setup_data
    end
  end
  
  def end_game(winner)
    broadcast({'winner' => winner, 'books' => @game.books}.to_json)
    @clients.each { |client| client.close }
  end
  
  def play_round
    input = JSON.parse(@clients[@game.turn - 1].gets)
    round_result = @game.take_turn(input['opponent'], input['card'])
    broadcast({'round_result' => round_result.as_json}.to_json)
  end
end

if __FILE__ == $0
  print "What port? Press [enter] for the default "
  port = gets.to_i
  port = 51528 if port == 0
  server = GoFishServer.new(port)
  print "How many players? Press [enter] for the default (4) "
  player_count = gets.to_i
  player_count = 4 if player_count < 2
  player_count.times { server.accept_connection }
  
  server.start_game
  
  until winner = server.winner
    server.send_turn
    server.send_hand_data
    server.play_round
  end
  
  server.end_game(winner)
  server.stop
end