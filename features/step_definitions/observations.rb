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
  expect(results).to eq(validation_error)
end

Then(/^I am shown a login form$/) do
  expect(page).to have_current_path('/admin/login')
end

Then(/^I should be shown the restricted content$/) do
  expect(page).to have_current_path('/admin/upload')
end