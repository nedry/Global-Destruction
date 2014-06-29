module TelnetSanitizer

  extend self

  def remove_telnet_sequences(s)
    s.gsub(TELNET_SEQUENCE, "")
  end

  private

  module Codes
    IAC  = 255.chr    # 0xff
    DONT = 254.chr    # 0xfe
    DO   = 253.chr    # 0xfd
    WONT = 252.chr    # 0xfc
    WILL = 251.chr    # 0xfb
    IP   = 244.chr    # 0xf4
    DM   = 242.chr    # 0xf2
  end
  include Codes

  TELNET_SEQUENCE = /
    #{IAC}#{IAC} |
    #{IAC}#{WILL}. |
    #{IAC}#{WONT}. |
    #{IAC}#{DO}. |
    #{IAC}#{DONT}. |
    #{IAC}#{IP} |
    #{IAC}#{DM}
  /mx

end
