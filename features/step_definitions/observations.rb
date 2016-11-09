And(/^I see '(.*)'$/) do |text|
  expect(page.body).to include(text)
end

Then(/^the response data should have (.*) items$/) do |num|
  result = JSON.parse(page.body)
  data = result['data']
  expect(data.count).to eq(num.to_i)
end

Then(/^I should see '(\d+) fatal errors'$/) do |fatal_count|
  expect(page.body).to include("#{fatal_count} fatal errors")
end