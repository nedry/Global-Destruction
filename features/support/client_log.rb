require "forwardable"

class ClientLog

  extend Forwardable

  def initialize
    @log_sections = []
    new_section
  end

  def_delegator :tail, :log_read
  def_delegator :tail, :log_write
  def_delegator :tail, :sanitized, :sanitized_tail

  def tail
    @log_sections.reverse.find do |log_section|
      !log_section.empty?
    end || @log_sections.last
  end

  def new_section
    @log_sections << ClientLogSection.new
  end

end
