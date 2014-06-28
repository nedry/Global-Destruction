#!/usr/bin/env ruby

$LOAD_PATH << "."

require 'top.rb'

module GlobalDestruction
  class RunSession

    attr_accessor :console

    def initialize
      @console = $stdout
    end

    def run
      $stdout.flush
      users = Users.new(@console)
      who = Who.new(@console)
      channels = Channel.new(@console)
      log = Log.new
      @ssock = ServerSocket.new(users, who, channels, log)
      @ssock.console = @console
      @ssock.run
    end

    def stop
      @ssock.close
    end

  end
end

GlobalDestruction::RunSession.new.run if $0 == __FILE__
