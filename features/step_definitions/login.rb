Given(/^I log in$/) do
  @client.wait_for /^>/
  @client.puts "fred"
  @client.wait_for "ENTER"
  @client.puts
  @client.wait_for "for menu"
end

Given(/^I am logged in$/) do
  step "I start the server"
  step "I connect"
  step "I log in"
end
