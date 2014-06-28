require_relative "client_socket"

class Client

  attr_accessor :host
  attr_accessor :port

  def initialize
    @client_socket = nil
    @host = "localhost"
    @port = 3000
  end

  def connected?
    @client_socket
  end

  def connect
    raise "Already connected" if connected?
    @client_socket = ClientSocket.new(@host, @port)
  end

  def output
    @client_socket.output
  end

  def puts(s = "")
    @client_socket.write(s + "\r")
  end

  def wait_for(pattern)
    unless pattern.is_a?(Regexp)
      pattern = Regexp.new(Regexp.escape(pattern))
    end
    match = nil
    Timeout.timeout(16) do
      until (match = pattern.match(@client_socket.output))
        @client_socket.wait_for_new_output
      end
    end
  end

end
