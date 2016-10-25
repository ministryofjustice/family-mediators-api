And(/^I see '(.*)'$/) do |text|
  expect(page.body).to include(text)
end

Then(/^the response data should have (\d+) items$/) do |num|
  result = JSON.parse(page.body)
  data = result['data']
  expect(data.count.to_i).to eq(7)
end