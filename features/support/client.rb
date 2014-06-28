require 'socket'

class Client

  attr_accessor :host
  attr_accessor :port

  def initialize
    @socket = nil
    @host = 'localhost'
    @port = 3000
  end

  def connected?
    @socket
  end

  def connect
    # raise "Already connected" if connected?
    # @socket = TCPSocket.new @host, @port
    @socket = :foo #DEBUG
  end

end

def client
  @client ||= Client.new
end
