And(/^I see '(.*)'$/) do |text|
  expect(page.body).to include(text)
end

And(/^I do not see '(.*)'$/) do |text|
  expect(page.body).to_not include(text)
end

Then(/^the response data should have (.*) items$/) do |num|
  result = JSON.parse(page.body)
  data = result['data']
  expect(data.count).to eq(num.to_i)
end

Then(/^the response should be mediator '(.*)'$/) do |urn|
  result = JSON.parse(page.body)
  expect(result['urn']).to eq(urn)
end

And(/^I should see the following (.*):$/) do |selector, expected_results|
  selector = '#' + selector.downcase.tr(' ', '-')
  results = get_table_data(selector)
  expected_results.diff!(results)
end

Then(/^the ids should be:$/) do |id_table|
  expected_ids = id_table.raw.flatten.map(&:to_i)
  result = JSON.parse(page.body)
  observed_ids = result['data'].map{ |item| item['id'] }
  expect(observed_ids).to eq(expected_ids)
end

Then(/^the validation error message should be (.*)$/) do |validation_error|
  selector = '#item-errors tbody'
  results = get_column_data(selector, 3)[0]
  expect(results).to eq(validation_error)
end

Then(/^I am shown the admin homepage$/) do
  expect(page).to have_current_path('/admin/')
end

Then(/^I am shown a login form$/) do
  expect(page).to have_current_path('/admin/login')
end

Then(/^I should be shown the restricted content$/) do
  expect(page).to have_current_path('/admin/upload')
end
