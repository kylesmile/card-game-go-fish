require 'socket'

class GoFishServer
  attr_reader :clients
  
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
end