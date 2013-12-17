#/(\d{1,2}).*?\b([a-z\d]+'?s?)[\?\.\!]?$/i # Complex ask player for card regular expression
#/\D*(\d).*([2-9]|10|[JQKA])/ # Simple "ask [player] for [card]"-only regular expresssion

require 'socket'

class GoFishPlayer
  COMMAND_MATCH = /(\d{1,2}).*?\b([a-z\d]+'?s?)[\?\.\!]?$/i # Player number and card

  def parse(string)
    if match = string.match(COMMAND_MATCH)
      opponent = match[1].to_i
      card = match[2].upcase

      card_name = card.match(/([2-9]|10|[JQKA])/)[0] # Get card name

      {opponent: opponent, card: card_name}
    end
  end

  def connect(host=nil, port=nil)
    host ||= 'kyle-laptop.local'
    port ||= 51528
    @socket = TCPSocket.new(host, port)
  end
end