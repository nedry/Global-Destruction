#!/usr/bin/ruby 
require "thread"
require "socket"
require 'tools.rb'
require 'globalconsts.rb'
require "class.rb"

class Session 
  def initialize(users, who, channel, log, socket) 
    @socket  = socket 
    @users  = users
    @who  = who
    @channel = channel
    @c_user  = nil     #name of current user in this session
    @wrap     = ''     #session varible for word wrapped text 
    @cmdstack  = Cmdstack.new   #session object for command stack
    @chatbuff = Array.new
    @log  = log
  end 

  require "misc.rb"
  require "io.rb"
  require "errors.rb"
  require "logon.rb"
  require "who.rb"
  require "userconf.rb"
  require "user.rb"
  require "line.rb"
  require "teleconference.rb"
  require "page.rb"
  require "main.rb"
  require "menu.rb"
  require "gd.rb"


  def run
    telnetsetup
    logon 
    commandLoop
  end
end

class Konsolethread
  include Enumerable, GdLogger
  require 'net/ftp'

  def initialize (users,who,channel,log)
    @who  = who
    @users  = users
    @channel  = channel
    @log  = log
    @idxlist = []
    @control = []
  end

  def run
    puts "-Starting Console Thread"
    while true
      sleep(4)
      #puts "-Console Crappy Mode Working"
      happy = IO.select([$stdin],nil,nil,0.1) 
      if happy != nil then
        happy = STDIN.getc
        puts happy
        case happy
        when 101;	repexport
        when 105;	qwkimport
        when 116;	clearoldqwk; ftppacketdown
        end
      end
    end 
  end
end #of class Konsolethread

class Happythread
  include Enumerable, GdLogger

  def initialize (users,who,channel,log)
    @who, @users, @channel, @log = who, users, channel, log
  end

  def each_user
    @who.each_index {|i| yield @users[@who[i].name]}
  end

  def each_name_with_index
    @who.each_index {|i| yield @who[i].name, i}
  end

  def removechannel(name)
    x = 0
    f = false
    puts "-Removing #{name} from all chat channels." 
    @channel.each {|chan|	
      chan.usrchannel.delete(name) {f = true}
      if !f then
        chan.line = "-#{name} has disconnected without logging out.  How rude!"
        chan.from = nil
        chan.count += 1
      end
    }
  end

  def run
    hit = false
    curthread = Array.new
    while true
      sleep (4)
      writelog('userlog.txt')
      curthread = Thread.list
      each_name_with_index {|name, i|
        if !curthread.any? {|thr| @who[i].threadn == thr}
          puts "-User #{i}:#{name} has disconnected."
          ddate = Time.now.strftime("%m/%d/%Y at %I:%M%p") 
          log ("%GUSER    :  %Y#{name} %Ghas disconnected at #{ddate}.")
          log ("")
          removechannel(@who[i].name)
          @who.delete(i)
          m = "%C#{name} %Ghas just disconnected from the system."
          each_user {|u| u.page.push(m)}
        end
      }
    end
  end
end #of class happythread

class ServerSocket

  attr_accessor :console

  def initialize(users, who, channel, log)
    @serverSocket = TCPServer.open(IP_PORT)
    @users = users
    @who = who
    @channel = channel
    @log = log
    @logged_on = false
    @console = $stdout
  end

  def run
    @console.puts "\n-Global Destruction Server\n"; $stdout.flush
    @users.loadusers
    @channel.append(Achannel.create("","Table #1","","","N/A","",false))
    @console.puts "\n-Starting GD_thread...."
    Thread.new {GD_thread.new(@users,@who,@channel,@log,0).run}
    @console.puts "\n-Starting Happy thread..."
    Thread.new {Happythread.new(@users,@who,@channel,@log).run}
    Thread.abort_on_exception = true  if DEBUG #debug mode.  thread crash stops app
    while true
      if socket = @serverSocket.accept then
        Thread.new {
          @console.puts "-New Incoming Connection"
          Session.new(@users,@who,@channel,@log,socket).run
        }
      end
    end
  rescue SystemCallError, IOError
  end

  def close
    begin
      @serverSocket.shutdown
    rescue Errno::ENOTCONN
    end
    @serverSocket.close
  end

end #class ServerSocket

def replogandputs(m)
  writereplog m
  puts m
end
