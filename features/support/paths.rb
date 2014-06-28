module Paths

  extend self

  def gem_path
    File.join(__dir__, "../..")
  end

  def server_path
    File.join(gem_path, "runsession.rb")
  end

end
