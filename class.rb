require 'tools.rb'

class Module
  # synchronised readers
  def sync_reader(mutexname, *args)
    args.each {|var|
      module_eval <<-here
                        def #{var.to_s}
                                #{mutexname}.synchronize {@#{var.to_s}}
                        end
                        here
    }
  end
  private :sync_reader
end

#logging functions. class must provide @log supporting @log.line.push
module GdLogger
  def log(string)
    @log.line.push string
  end

  def writelog(logfile)
    fname = File.join(TEXTPATH, logfile)
    if @log.line.length > 0 then
      lf = File.new(fname, File::CREAT|File::APPEND|File::RDWR, 0644)
      @log.line.each {|x|
        if x == "REWRITE" then
          lf.close
          rewritelog(logfile)
          lf = File.new(fname, File::CREAT|File::APPEND|File::RDWR, 0644)
        else
          lf.puts x
        end
      }
      @log.line.clear
      lf.close
    end
  end

  def rewritelog(logfile)
    fname = File.join(TEXTPATH, logfile)
    if File.exists?(fname) then
      lf = File.new(fname, File::TRUNC|File::RDWR, 0644)
      lf.close
    end
  end
end

#base class for channel, user etc lists
class Listing
  include Enumerable

  def initialize(console, data_dir)
    @console = console
    @data_dir = data_dir
    @mutex = Mutex.new
    @list = Array.new
  end

  def each
    @list.each {|n| yield n}
  end

  def each_index
    @list.each_index {|i| yield i}
  end

  def each_with_index
    @list.each_with_index {|n,i| yield n,i}
  end

  def findkey(key)
    @mutex.synchronize {
      key.kind_of?(Integer) ?  @list[key] :
      @list.find {|v| key == yield(v)}
    }
  end

  def append(val)
    @mutex.synchronize {
      @list.push(val)
      self
    }
  end

  def delete(val)
    @mutex.synchronize {
      @list.delete_at(val)
      self
    }
  end

  def len
    return @list.length
  end

  def savelist(filename)
    path = File.join(@data_dir, filename)
    @mutex.synchronize {
      File.open(path, "w+") do |f|
        Marshal.dump( @list, f) ##
      end
    }
  end

  def loadlist(filename, listname, console)
    path = File.join(@data_dir, filename)
    @mutex.synchronize {
      @console.puts "-Loading #{listname}"
      if File.exists?(path)
        File.open(path) do |f|
          @list = Marshal.load(f)  ##
        end
      else
        @list = defaultlist
        @console.puts "-#{listname.capitalize} not Found.  Creating new #{listname}"
        File.open(path, "w+") do |f|
          Marshal.dump(@list, f) ##
          @console.puts "-Saving #{listname}..."
        end
      end
    }
  end
end

Achannel = Struct.new('Achannel',       :deleted, :to, :from, :name, :count, :line,
  :status, :createdby, :password, :usrchannel, :v_usrchannel, :g_buffer, :a_player,
  :locked,:players,:usd_countries)
class Achannel
  private :initialize

  class << self
    def create(line, name, to, from, createdby, password, status)
      a = self.new
      a.deleted = false
      a.to                        = to
      a.from                    = from
      a.name                    = name
      a.count           = 0
      a.line                    = line
      a.status = status
      a.password        = password
      a.usrchannel              = []
      a.v_usrchannel    = []                            #Vitural Users
      a.g_buffer                  = []                          #Buffer for command processing
      a.players = []
      a.a_player = nil
      a.locked = false
      a.usd_countries = [] #Countries in use
      return a
    end
  end
end

class Channel < Listing
  def initialize(console, data_dir)
    super
  end

  def [](key)
    findkey(key) {|channel| channel.line}
  end

  sync_reader '@mutex', :deleted, :name, :count, :to, :from, :createdby, :line,
  :status, :usrchannel, :v_usrchannel, :g_buffer,:a_player,:locked,:players,:usd_countries
end   #of Class channel

Awho = Struct.new('Awho', :level, :location,:where, :threadn, :date, :name)
class Awho
  private :initialize
  class << self
    def create(name,location,threadn,level)
      a = self.new
      a.date            = Time.now
      a.name            = name
      a.location        = location
      a.threadn = threadn
      a.level           = level
      a.where           = "Logon"
      return a
    end
  end
end

class Who < Listing
  def initialize(console, data_dir)
    super
  end

  sync_reader '@mutex', :date, :threadn, :location, :name, :level, :where

  def [](key)
    findkey(key) {|who| who.threadn}
  end

  def user(key)
    findkey(key.upcase) {|who| who.name.upcase}
  end
end   #of Class Who


class Parse
  class << self
    def parse(input)
      temp = input.scan(/\d+/)
      [0,1].map {|i| (temp[i] || -1).to_i}
    end
  end
end

class Cmdstack
  def initialize
    @cmd = Array.new
  end

  attr_accessor :cmd

  def pullapart (input)
    happy = input.split(/\s*;\s*/)
    @cmd = happy if happy
  end
end #of def

class Log
  def initialize
    @line = Array.new
    @mutex = Mutex.new
  end

  attr_accessor :line
  sync_reader '@mutex', :line
end #of class Log

class LineEditor
  def initialize
    @msgtext    = []
    @line               = 0
    @save               = false
  end
  attr_accessor :msgtext, :line, :save
end

User = Struct.new('User',:created, :deleted, :alais, :locked, :name, :phone,
  :citystate, :address, :password, :length, :width, :ansi, :more, :level,:created,
  :modified, :laston,  :logons, :posted, :page,:channel)
class User
  private :initialize
  class << self
    def create(name,  phone, citystate, address, password, length, width,
        ansi, more, level)
      a = self.new
      a.deleted = false
      a.locked  = false
      a.name    = name
      a.alais           = ''
      a.phone   = phone
      a.citystate       = citystate
      a.address         = address
      a.password        = password
      a.length  = length
      a.width   = 80
      a.ansi            = ansi
      a.more            = more
      a.level           = level
      a.created = Time.now
      a.modified        = Time.now
      a.laston  = Time.now
      a.logons  = 0
      a.posted  = 0
      a.page            = []
      a.channel = 0
      return a
    end
  end

  def show
    print "User: #@name #@phone #@citystate #@address #@password\n"
  end
end # of User Object

class Users < Listing
  def initialize(console, data_dir)
    super
  end

  def loadusers
    loadlist('users.dat','User file', @console)
  end

  def defaultlist
    sysop =     User.create('SYSOP', '000.000.000.000', 'Anytown, USA',
      '123 Sample Street', 'STUPID', 24, 80, true, true, 255)
    return [sysop]
  end

  sync_reader '@mutex', :created, :deleted, :alais, :locked, :name, :phone,
  :citystate, :address, :password, :length, :width, :ansi, :more, :level,:created,
  :modified, :laston,  :logons, :posted, :page,:channel

  def findalais(key)
    findkey(key.upcase) {|user| user.alais.upcase}
  end

  def [](key)
    key = key.upcase if !key.kind_of?(Integer)
    findkey(key) {|user| user.name.upcase}
  end

  def saveusers
    savelist('users.dat')
  end

  def checkpassword (username,password)
    @mutex.synchronize {
      if self[username] != nil
        return (self[username].password == password)
      else
        puts CRLF+"-Bad username passed to def:checkpassword.  Please tell sysop!"
        return false
      end
    }
  end
end   #of Class User_list
