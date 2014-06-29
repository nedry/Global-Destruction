require "net/telnet"

require_relative "client_log"
require_relative "logging_socket"

class Client

  attr_accessor :host
  attr_accessor :port

  def initialize
    @telnet = nil
    @host = "localhost"
    @port = 3000
    @output = StringIO.new
    @client_log = ClientLog.new
  end

  def connected?
    @telnet
  end

  def connect
    raise "Already connected" if connected?
    @socket = TCPSocket.new(@host, @port)
    @logging_socket = LoggingSocket.new(@socket, @client_log)
    @telnet = Net::Telnet.new("Proxy" => @logging_socket)
  end

  def puts(s = "")
    @telnet.puts s
  end

  def wait_for(pattern)
    unless pattern.is_a?(Regexp)
      pattern = Regexp.new(Regexp.escape(pattern))
    end
    @telnet.waitfor("Match" => pattern)
    @client_log.new_section
  rescue Net::ReadTimeout
    Kernel::puts @client_log.sanitized_tail
    raise "Timeout waiting for #{pattern.inspect}"
  end

end
