require 'spec_helper'


class MockGoFishServer
    def initialize
        @server = TCPServer.new(51528)
    end

    def accept_connection
        @server.accept
    end
end


describe GoFishPlayer do
  before do
    @player = GoFishPlayer.new
  end

  it "properly parses input" do
    expect(@player.parse("Player 2, do you have any aces?")).to eq({opponent: 2, card: 'A'})
    expect(@player.parse("Does player 3 have any 2s?")).to eq({opponent: 3, card: '2'})
    expect(@player.parse("Player 4 give me all your 8's.")).to eq({opponent: 4, card: '8'})
    expect(@player.parse("ask 3 for 10")).to eq({opponent: 3, card: '10'})
    expect(@player.parse("7 9")).to eq({opponent: 7, card: '9'})
    expect(@player.parse("10 for J")).to eq({opponent: 10, card: 'J'})
    expect(@player.parse("Blah blah blah")).to be_nil
  end

  it "connects to the server" do
    server = MockGoFishServer.new
    expect { @player.connect('localhost', 51528) }.not_to raise_error
  end
end