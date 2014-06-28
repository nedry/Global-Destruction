require "net/telnet"

require_relative "client_log"

class Client

  attr_accessor :host
  attr_accessor :port

  def initialize
    @telnet = nil
    @host = "localhost"
    @port = 3000
    @output = StringIO.new
    @log = ClientLog.new
  end

  def connected?
    @telnet
  end

  def connect
    raise "Already connected" if connected?
    @telnet = Net::Telnet.new(
      "Host" => @host,
      "Port" => @port,
      "Output_log" => @log.path,
    )
  end

  def puts(s = "")
    @telnet.puts s
  end

  def wait_for(pattern)
    unless pattern.is_a?(Regexp)
      pattern = Regexp.new(Regexp.escape(pattern))
    end
    @telnet.waitfor("Match" => pattern)
  rescue Net::ReadTimeout
    Kernel::puts @log.sanitized_tail
    raise "Timeout waiting for #{pattern.inspect}"
  end

end
