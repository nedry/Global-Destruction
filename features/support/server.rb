require 'socket'

require_relative "../../runsession"

class Server

  attr_accessor :port

  def initialize
    @run_session = GlobalDestruction::RunSession.new
    @run_session.console = NullOut.new
  end

  def host
    "localhost"
  end

  def port
    3000
  end

  def start
    raise "Already started" if @thread
    @thread = Thread.new do
      Thread.current.abort_on_exception = true
      Dir.chdir(File.join(__dir__, "../..")) do
        @run_session.run
      end
    end
    wait_until { ready? }
  end

  def ready?
    socket = TCPSocket.new(host, port)
    true
  rescue Errno::ECONNREFUSED
    false
  end

  def shutdown
    @run_session.stop
    wait_until { !ready? }
  end

  private

  def wait_until
    Timeout.timeout(8) do
      until yield do
        sleep 0.05
      end
    end
  end

end
