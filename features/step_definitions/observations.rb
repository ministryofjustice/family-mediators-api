And(/^I see '(.*)'$/) do |text|
  expect(page.body).to include(text)
end

Then(/^the response data should have (.*) items$/) do |num|
  result = JSON.parse(page.body)
  data = result['data']
  expect(data.count).to eq(num.to_i)
end

And(/^I should see the following (#{ERROR_TABLE_SELECTOR}):$/) do |selector, expected_results|
  results = get_table_data(selector)
  expected_results.diff!(results)
end