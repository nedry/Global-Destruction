#!/usr/bin/env ruby

$LOAD_PATH << "."

require 'top.rb'

module GlobalDestruction
  class RunSession

    attr_accessor :console
    attr_accessor :data_dir

    def initialize
      @console = $stdout
      @data_dir = __dir__
    end

    def run
      $stdout.flush
      users = Users.new(@console, @data_dir)
      who = Who.new(@console, @data_dir)
      channels = Channel.new(@console, @data_dir)
      log = Log.new
      @ssock = ServerSocket.new(
        users,
        who,
        channels,
        log,
        @console,
        @data_dir
      )
      @ssock.run
    end

    def stop
      @ssock.close
    end

  end
end

GlobalDestruction::RunSession.new.run if $0 == __FILE__
