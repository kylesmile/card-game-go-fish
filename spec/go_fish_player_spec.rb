require 'spec_helper'

class MockGoFishServer
    def initialize
        @server = TCPServer.new(51528)
    end

    def accept_connection
        @socket = @server.accept
    end
    
    def stop_server
      @server.close
    end
    
    def send_player_number
      @socket.puts({'player_number' => 1}.to_json)
    end
    
    def send_hand_data
      hand = GoFishHand.new([PlayingCard.new('A', 'S'), PlayingCard.new('J', 'D'), PlayingCard.new('Q', 'C')])
      hand_data = {'hand' => hand.as_json}
      hand_data['hand_sizes'] = [3,5,4,6]
      @socket.puts(hand_data.to_json)
    end
    
    def send_turn
      @socket.puts({'turn' => 1}.to_json)
    end
    
    def client_input
      @socket.read_nonblock(1000).chomp
    rescue Errno::EAGAIN
      nil
    end
end

describe GoFishPlayer do
  before do
    @player = GoFishPlayer.new
  end

  context "not requiring server interaction" do
    it "properly parses input" do
      expect(@player.parse("Player 2, do you have any aces?")).to eq({opponent: 2, card: 'A'})
      expect(@player.parse("Does player 3 have any 2s?")).to eq({opponent: 3, card: '2'})
      expect(@player.parse("Player 4 give me all your 8's.")).to eq({opponent: 4, card: '8'})
      expect(@player.parse("ask 3 for 10")).to eq({opponent: 3, card: '10'})
      expect(@player.parse("7 9")).to eq({opponent: 7, card: '9'})
      expect(@player.parse("10 for J")).to eq({opponent: 10, card: 'J'})
      expect(@player.parse("Blah blah blah")).to be_nil
    end
  end

  context "requiring server interaction" do
    before do
      @server = MockGoFishServer.new
    end
    
    after do
      @server.stop_server
    end
    
    it "connects to the server" do
      expect { @player.connect('localhost', 51528) }.not_to raise_error
      @server.accept_connection
      @server.send_player_number
      @player.receive_from_server
      expect(@player.player_number).to eq(1)
    end
    
    context "already connected to the server" do
      before do
        @player.connect('localhost')
        @server.accept_connection
        @server.send_player_number
        @player.receive_from_server
        @server.send_hand_data
        @player.receive_from_server
      end
      
      it "receives hand data from the server" do
        expect(@player.hand.number_of_cards).to eq(3)
        expect(@player.hand.books).to eq(0)
        expect(@player.hand_sizes[2]).to eq(4)
      end
      
      it "only sends user input to the server on that player's turn" do
        expect(@player.send_user_input("ask 3 for J")).to eq("It's not your turn")
        expect(@server.client_input).to be_nil
        
        @server.send_turn
        @player.receive_from_server
        
        @player.send_user_input("ask 3 for J")
        expect(@server.client_input).to eq('{"opponent":3,"card":"J"}')
      end
      
      it "only sends good user input to the server" do
        @server.send_turn
        @player.receive_from_server
        
        expect(@player.send_user_input("Blah blah blah")).to eq("What's that supposed to mean?")
        expect(@server.client_input).to be_nil
        
        expect(@player.send_user_input("Player 2, do you have any 2s")).to eq("You don't have any cards of that rank")
        expect(@server.client_input).to be_nil
        
        expect(@player.send_user_input("Player 5, do you have any Jacks")).to eq("That player doesn't exist")
        expect(@server.client_input).to be_nil
        
        @player.send_user_input("Player 2, do you have any aces?")
        expect(@server.client_input).to eq('{"opponent":2,"card":"A"}')
      end
    end
  end
end