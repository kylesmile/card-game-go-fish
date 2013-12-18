require 'spec_helper'

class MockPlayer
  attr_reader :socket
  
  def connect
    @socket = TCPSocket.new('localhost', 51528)
  end
end

describe GoFishServer do
  before do
    @server = GoFishServer.new
  end
  
  after do
    @server.close
  end
  
  it "accepts client connections" do
    player = MockPlayer.new
    expect { player.connect }.not_to raise_error
    
    expect(@server.clients.count).to eq(0)
    
    @server.accept_connection
    
    expect(@server.clients.count).to eq(1)
  end
   
  it "sets up the game when it gets enough connections" do
    
  end
end