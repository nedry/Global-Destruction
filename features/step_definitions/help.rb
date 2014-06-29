When(/^I ask for help$/) do
  @client.puts "?"
  @client.wait_for_prompt
end

Then(/^I should see help$/) do
  expect(@client.tail).to include "[G]oodbye"
end
