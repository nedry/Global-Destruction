require_relative "ansi_sanitizer"
require_relative "telnet_sanitizer"

class ClientLogSection

  include AnsiSanitizer
  include TelnetSanitizer

  def initialize
    @log = ""
  end

  def log_read(string)
    @log << string
  end

  def log_write(string)
    @log << string
  end

  def sanitized
    s = remove_ansi_sequences(@log)
    s = remove_telnet_sequences(s)
    s = remove_nulls(s)
    s
  end

  def empty?
    @log.empty?
  end

  private

  def remove_nulls(s)
    s.gsub(/\0/, "")
  end

end
