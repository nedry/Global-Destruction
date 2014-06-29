require 'forwardable'

class LoggingSocket

  extend Forwardable

  def initialize(socket, client_log)
    @socket = socket
    @client_log = client_log
  end

  def kind_of?(o)
    super || o == IO
  end

  def to_io
    @socket
  end

  def syswrite(string)
    @client_log.log_write(string)
    @socket.syswrite(string)
  end

  def readpartial(maxlen)
    string = @socket.readpartial(maxlen)
    @client_log.log_read(string)
    string
  end

end
