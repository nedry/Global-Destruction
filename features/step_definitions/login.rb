Given(/^I log in$/) do
  @client.wait_for /^>/
  @client.puts "fred"
  @client.wait_for "? for menu"
end
