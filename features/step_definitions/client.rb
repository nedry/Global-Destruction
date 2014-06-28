Before do
  @client = Client.new
end

When(/^I connect$/) do
  @client.host = @server.host
  @client.port = @server.port
  @client.connect
end
