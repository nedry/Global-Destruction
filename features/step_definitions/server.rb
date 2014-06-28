Before do
  @server = Server.new
end

Given(/^I start the server$/) do
  @server.start
end

After do
  @server.shutdown
end
