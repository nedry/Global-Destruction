require 'top.rb'

#  ------------------ MAIN ------------------


$stdout.flush

users = Users.new
who = Who.new
channels = Channel.new
log = Log.new

ssock = ServerSocket.new(users, who, channels, log)

#puts "Calling 'run'"; $stdout.flush
ssock.run
