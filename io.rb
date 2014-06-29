require 'tools.rb'
require 'globalconsts.rb'
require 'wrap.rb'

class Session
  include GdLogger

  # Input a line a character at a time.
  def getstr(echo, wrapon, width, prompt, chat)
    whole = "" # return value
    suppress = false # prevent telnet control codes being treated as user input
    idle = 0
    tick = Time.now.min.to_i

    warn  = @c_user ? RIDLEWARN : LIDLEWARN
    limit = @c_user ? RIDLELIMIT : LIDLELIMIT

    todotime = limit - warn
    warned = false

    count = @c_user ? @channel[@users[@c_user].channel].count : nil

    whole = @wrap.to_s # takes care of nil
    i = whole.length

    @wrap = ''
    @socket.write whole

    while true do
      char = 0
      if select([@socket],nil,nil,0.1) != nil then
        char = @socket.getc.ord
      else
        if @c_user != nil
          page = @users[@c_user].page
          unless (page.nil? || page.empty? )
            print
            page.each {|x| print
              w_out = WordWrapper.wrap(x,@users[@c_user].width)
              write w_out}
            page.clear
            print;write prompt;write whole
          end
        end

        time = Time.now
        tick = 0 if time.min.to_i == 0

        if time.min.to_i > tick then
          idle = idle + 1
          tick = time.min.to_i
        end

        if !chat
          warned = warntimeout(idle, warn, warned, limit, todotime, prompt)
        else
          count = printchat(count, whole, prompt)
        end
      end

      next if char == 0

      idle = 0
      warned = false
      case char
      when TELNETCMD; suppress = true
      when CR;  @socket.write CRLF; break
      when BS;  i, whole = delchar(i, whole)
      when DBS; i, whole = delchar(i, whole) #for UNIX based Telnet
      when PRINTABLE
        i = i + 1
        if !suppress then
          whole << char.chr
          @socket.write(echo ? char.chr : NOECHOCHAR.chr)
        end
        whole = wrapstr(whole, i, width, char) if wrapon
      end  #of case

      suppress = false if char < 250
    end #of iterator

    @socket.flush
    return whole
  end

  def printchat(count, whole, prompt)
    channel = @channel[@users[@c_user].channel]
    if count != channel.count then
      separator, col1 = (channel.from != nil) ? [': %G', '%M'] : [nil, nil]
      chanline = [col1, channel.from, separator, channel.line].to_s
      if (whole == '') then
        w_out = WordWrapper.wrap(chanline,@users[@c_user].width)
        print CRLF+w_out
        write prompt
      else
        @chatbuff.push(chanline)
      end
      count = channel.count
    end
    count
  end

  def warntimeout(idle, warn, warned, limit, todotime, prompt)
    if (idle >= limit)
      print; print "Idle time limit exceeded.  Disconnecting!"
      print "NO CARRIER"
      sleep(5)
      hangup
    end

    if (idle >= warn) and (!warned)
      if todotime > 1 then tempstr = "minutes" else tempstr = "minute" end
      print; print "You have #{todotime} #{tempstr} in which to do something!"
      write prompt
      warned = true
    end

    return warned
  end

  def wrapstr(whole, i, width, char)
    if (i >= width - 2)  then
      if char != 32
        wlen = 0
        @wrap = whole.scan(/\w+/).last
        wlen = @wrap.length if @wrap != nil
        @socket.write(BS.chr)*wlen + " "*wlen + CRLF
        endbit = whole.length - wlen
        whole.slice!(endbit..whole.length)
        #break
        return whole
      end
      print
      @socket.write CRLF
      #break
      return whole
    end
    return whole
  end

  def delchar(i, whole)
    if i > 0
      @socket.write BS.chr
      return i-1, whole.chop
    else
      return i, whole
    end
  end

  def getcmd(prompt, echo, size, chat)
    if @cmdstack.cmd.empty?
      write prompt
      tempstr = getstr(echo,NOWRAP,size,prompt,chat).strip
      @cmdstack.pullapart(tempstr)
    end
    nilv(@cmdstack.cmd.shift, "")
  end

  def getcmdandtest(prompt, echo, size, chat, errmsg)
    while true do
      t = getcmd(prompt, echo, size, chat)
      break if yield t
      print errmsg
    end
    print
    return t
  end

  def getnum(prompt, low, high, default, width, chat)
    errmsg = "Must be between #{low} and #{high}."
    t = getcmdandtest(prompt, ECHO, width, chat, errmsg ) {|cmd|
      (low..high).include?(cmd.to_i)
    }
    return t.to_i
  end

  def _getinputlen(prompt, echo, size, chat)
    getcmdandtest(prompt, echo, size, chat, '') {|cmd|
      cmd.length >= size
    }
  end

  def getinputlen(prompt, echo, size, chat, errmsg = nil)
    if block_given?
      while true do
        t = _getinputlen(prompt, echo, size, chat)
        break if yield t
        print errmsg
      end
      print
      return t
    else
      _getinputlen(prompt, echo, size, chat)
    end
  end

  def getinp(prompt, errmsg = nil, &block)
    # print "in getinp"
    if block_given?
      # print "block given"
      while true do
        t = getcmd(prompt, ECHO, 0, false)
        break if yield t
        print errmsg if errmsg
      end
      print
      return t
    else
      getcmd(prompt, ECHO, 0, false)
    end
  end

  def getinp_c(prompt, errmsg = nil, &block)
    # print "in getinp"
    if block_given?
      # print "block given"
      while true do
        t = getcmd(prompt, ECHO, 0, true)
        break if yield t
        print errmsg if errmsg
      end
      print
      return t
    else
      getcmd(prompt, ECHO, 0, true)
    end
  end

  def _getnum(prompt, low = nil, high = nil)
    while true
      a = getinp(prompt)
      if a == ""
        return nil
      elsif !a.integer?
        print "Input must be a number"
      else
        a = a.to_i
        if (low && (a < low)) or (high && (a > high))
          print "Must be between #{low} and #{high}"
        else
          return a
        end
      end
    end
  end

  def getnum(prompt, low = nil, high = nil, errmsg = "")
    if block_given?
      while true
        t = _getnum(prompt, low, high)
        return t if yield t
        print errmsg
      end
    else
      return _getnum(prompt, low, high)
    end
  end

  def getpwd(prompt, &block)
    getinputlen(prompt, NOECHO, 3, false, &block).strip.upcase
  end

  def getandconfirmpwd
    while true
      p1 = getpwd("Enter new password: ")
      break if p1 == ""
      p2 = getpwd("Enter again to confirm: ")
      break if p1 == p2
      print "Passwords don't match - try again"
    end
    p1 == "" ? nil : p1
  end

  def yes(prompt,default,chat)
    validanswers = {"Y" => true, "N" => false, "" => default}
    ans = ''
    t = getcmdandtest(prompt, ECHO, 0, chat, "") {|cmd|
      ans = cmd.upcase.strip
      validanswers.has_key?(ans)
    }
    return validanswers[ans]
  end

  def hangup
    @socket.flush
    @socket.close
  end

  #make sure everything goes through this!
  def parse_c(line)

    line = line.to_s.gsub("\t",'')
    if @logged_on then
      COLORTABLE.each_pair {|color, result|
        line.gsub!(color) {if @users[@c_user].ansi == true then result else  '' end}
      }
    end
    return line
  end


  # Write line without CR
  def write(line = '')
    @socket.write parse_c(line.to_s)
  end

  # Write line with CR
  def print(line = '')
    line = line.to_s.gsub("\n","#{CRLF}")
    @socket.write(parse_c(line) + CRLF)
  end

  def moreprompt
    moreprompt = yes("More (Y,n)? ", true, false)
  end

  def telnetsetup
    # put the remote telnet client into "character at a time mode"
    # TELNET protocol sucks!
    [255,251,1,255,251,3].each {|i| write i.chr}
  end

  def ogfileout (filename,offset,override)

    graphfile = File.join(TEXTPATH, filename + ".gra")
    plainfile = File.join(TEXTPATH, filename + ".txt")

    outfile = filename

    if override then
      outfile = File.exists?(graphfile) ? graphfile : plainfile
    end

    j = offset
    cont = true
    if File.exists?(outfile)
      IO.foreach(outfile) { |line|
        j = j + 1
        if j == @users[@c_user].length and @users[@c_user].more then
          cont = moreprompt
          j = 1
        end
        break if !cont
        write line + "\r"
      }
    else
      print "\n#{outfile} has run away...please tell sysop!\n"
    end
    print; print
  end

  def fileout (filename)
    if File.exists?(filename)
      IO.foreach(filename) { |line| write line + "\r" }
    else
      print "\n#{filename} has run away...please tell sysop!\n"
    end
    print; print
  end

  def gfileout (filename)
    graphfile = File.join(TEXTPATH, filename + ".gra")
    plainfile = File.join(TEXTPATH, filename + ".txt")
    if @users[@c_user].ansi == TRUE
      fileout(File.exists?(graphfile) ? graphfile : plainfile)
    else
      fileout(plainfile)
    end
  end

end # class Session
