And(/^I see '(.*)'$/) do |text|
  expect(page.body).to include(text)
end

Then(/^the response data should have (.*) items$/) do |num|
  result = JSON.parse(page.body)
  data = result['data']
  expect(data.count).to eq(num.to_i)
end

And(/^I should see the following (.*):$/) do |selector, expected_results|
  selector = '#' + selector.downcase.tr(' ', '-')
  results = get_table_data(selector)
  expected_results.diff!(results)
end

Then(/^the validation error message should be (.*)$/) do |validation_error|
  selector = '#item-errors tbody'
  results = get_column_data(selector, 3)[0]
  expect(validation_error).to eq(results)
end