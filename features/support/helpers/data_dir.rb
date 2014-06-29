require "fileutils"
require "tmpdir"

class DataDir

  def initialize
    @path = Dir.mktmpdir
    at_exit { FileUtils.rm_rf(@path) }
  end

  def path
    @path
  end

end
