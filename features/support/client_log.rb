require "tempfile"

require_relative "ansi_sanitizer"

class ClientLog

  include AnsiSanitizer

  def initialize
    file = Tempfile.new('client_log')
    file.close
    @path = file.path
  end

  def path
    @path
  end

  def sanitized_tail
    remove_ansi_sequences(tail)
  end

  private

  def tail
    Array(File.readlines(@path)[-20..-1]).join
  end

end
