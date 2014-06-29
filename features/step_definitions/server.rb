Before do
  @data_dir = DataDir.new
  @server = Server.new(@data_dir)
end

Given(/^I start the server$/) do
  @server.start
end

After do
  return unless @server
  @server.shutdown
end
