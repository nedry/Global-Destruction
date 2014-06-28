require "io/wait"
require "monitor"
require "socket"
require "thread"
require "timeout"

class ClientSocket

  attr_accessor :host
  attr_accessor :port

  def initialize(host, port)
    @output = ""
    @output.extend(MonitorMixin)
    @socket = TCPSocket.new(host, port)
    Thread.new { listen }
  end

  def output
    @output.synchronize do
      @output
    end
  end

  def wait_for_new_output
    IO.select([@socket], nil, nil, 1)
  end

  def write(s)
    @socket.write(s)
  end

  private

  def listen
    Thread.new do
      Thread.abort_on_exception = true
      loop do
        store_output(read_socket)
      end
    end
  end

  def read_socket
    begin
      @socket.read_nonblock(1024)
    rescue IO::WaitReadable
      wait_for_new_output
      retry
    end
  end

  def store_output(s)
    @output.synchronize { @output << s }
  end

end
