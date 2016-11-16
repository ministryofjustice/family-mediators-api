And(/^I see '(.*)'$/) do |text|
  expect(page.body).to include(text)
end

Then(/^the response data should have (.*) items$/) do |num|
  result = JSON.parse(page.body)
  data = result['data']
  expect(data.count).to eq(num.to_i)
end


And(/^I should see the following collection errors:$/) do |expected_results|
  results = []
  page.all('#collection-errors thead tr').map do |tr|
    col_1 = tr.all('th')[0].text
    col_2 = tr.all('th')[1].text
    results << [col_1, col_2]
  end
  page.all('#collection-errors tbody tr').map do |tr|
    col_1 = tr.all('td')[0].text
    col_2 = tr.all('td')[1].text
    results << [col_1, col_2]
  end
  expected_results.diff!(results)
end