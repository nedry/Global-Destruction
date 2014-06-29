module AnsiSanitizer

  extend self

  ANSI_SEQUENCE = /\e\[.*?[@-~]/

  def remove_ansi_sequences(s)
    s.gsub(ANSI_SEQUENCE, "")
  end

end
