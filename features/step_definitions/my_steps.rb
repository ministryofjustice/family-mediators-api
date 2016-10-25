Given(/^I upload a well-formed spreadsheet/) do
  visit 'http://localhost:9292/admin/'
  file_path = File.expand_path('../../support/fixtures/uploaded_spreadsheet.xlsx', __FILE__)
  attach_file('spreadsheet_file', file_path)
  find('input[type="submit"]').click
end

Then(/^I should see the size of the file$/) do
  file_path = File.expand_path('../../support/fixtures/uploaded_spreadsheet.xlsx', __FILE__)
  size = File.open(file_path, 'r').size
  expect(page.body).to include("Size: #{size}")
end


When(/^I visit '(.*)'$/) do |endpoint|
  url = "http://localhost:9292#{endpoint}"
  visit url
end