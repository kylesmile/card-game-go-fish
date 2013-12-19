require 'spec_helper'

class MockPlayer
  attr_reader :socket
  
  def initialize
    @socket = TCPSocket.new('localhost', 51528)
  end
  
  def server_input
    @socket.read_nonblock(1000).chomp
  rescue Errno::EAGAIN
    nil
  end
  
  def send_message(message)
    @socket.puts(message)
  end
end

describe GoFishServer do
  before do
    @server = GoFishServer.new
  end
  
  after do
    @server.stop
  end
  
  it "accepts client connections" do
    expect { player = MockPlayer.new }.not_to raise_error
    
    expect(@server.clients.count).to eq(0)
    
    @server.accept_connection
    
    expect(@server.clients.count).to eq(1)
  end
  
  it "sets up the game if it has enough connections" do
    @server.start_game
    expect(@server.game).to be_nil
    
    player1 = MockPlayer.new
    @server.accept_connection
    @server.start_game
    expect(@server.game).to be_nil
    
    player2 = MockPlayer.new
    @server.accept_connection
    @server.start_game
    expect(@server.game).not_to be_nil
  end
  
  context "with players already connected" do
    before do
      @player1 = MockPlayer.new
      @server.accept_connection
      @player2 = MockPlayer.new
      @server.accept_connection
    end
    
    it "broadcasts and narrow-casts to players" do
      @server.broadcast("Hi, everyone!")
      sleep(0.0001)
      expect(@player1.server_input).to eq("Hi, everyone!")
      expect(@player2.server_input).to eq("Hi, everyone!")
      
      @server.narrowcast("Hi, player 2", 2)
      expect(@player1.server_input).to be_nil
      expect(@player2.server_input).to eq("Hi, player 2")
    end
        
    it "sends setup data" do
      @server.start_game
      input1 = JSON.load(@player1.server_input)
      input2 = JSON.load(@player2.server_input)
      
      expect(input1['player_number']).to eq(1)
      expect(input2['player_number']).to eq(2)
      
      @server.send_hand_data
      input1 = JSON.load(@player1.server_input)
      input2 = JSON.load(@player2.server_input)
      
      expect(input1['hand']).not_to be_nil
      expect(input2['hand']).not_to be_nil
      
      expect(input1['hand_sizes']).to eq([7,7])
      expect(input2['hand_sizes']).to eq([7,7])
      
      expect(input1['books']).to eq([0,0])
      expect(input2['books']).to eq([0,0])
    end
    
    it "sends turn data" do
      @server.start_game
      @player1.server_input
      @player2.server_input
      
      @server.send_turn
      input1 = JSON.load(@player1.server_input)
      input2 = JSON.load(@player2.server_input)
      
      expect(input1['turn']).to eq(1)
      expect(input2['turn']).to eq(1)
    end
      
    context "with game already started" do
      before do
        hand1 = GoFishHand.new([PlayingCard.new('A', 'S'), PlayingCard.new('A','D')])
        hand2 = GoFishHand.new([PlayingCard.new('A', 'H')])
        deck = CardDeck.new(['AC'])
        @server.start_game([hand1, hand2], deck)
        @server.send_turn
        @player1.server_input
        @player2.server_input
      end
      
      it "plays a round based on user input" do
        @player1.send_message({opponent: 2, card: 'A'}.to_json)
        @server.play_round
        input = @player1.server_input
        round_result = JSON.load(input)['round_result']
        expect(round_result.turn).to eq(1)
        expect(round_result.wanted).to eq('A')
        expect(round_result.got).to eq(true)
        expect(round_result.amount).to eq(1)
        expect(round_result.from).to eq(2)
        expect(round_result.source).to eq("Player 2")
        expect(round_result.new_books).to eq(0)
      end
      
      it "broadcasts the winner" do
        @player1.send_message({opponent: 2, card: 'A'}.to_json)
        @server.play_round
        @player1.send_message({opponent: 2, card: 'A'}.to_json)
        @server.play_round
        sleep(0.0001)
        @player1.server_input
        @player2.server_input
        
        @server.end_game(@server.winner)
        sleep(0.0001)
        input1 = JSON.parse(@player1.server_input)
        input2 = JSON.parse(@player2.server_input)
        
        expect(input1['winner']).to eq(1)
        expect(input2['winner']).to eq(1)
        expect(input1['books']).to eq([1,0])
        expect(input2['books']).to eq([1,0])
        
        @player1.send_message("Hi")
        expect {@player1.send_message("Hi")}.to raise_error
      end
    end
  end
end