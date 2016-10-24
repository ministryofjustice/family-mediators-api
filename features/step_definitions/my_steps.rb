Given(/^I visit the Mediators Admin homepage/) do
  visit 'http://localhost:9292/admin/'
end

Then(/^I should see '(.*)'/) do |text|
  expect(page.body).to include(text)
end

When(/^I upload a file$/) do
  file_path = File.expand_path('../../support/fixtures/uploaded_spreadsheet.xlsx', __FILE__)
  attach_file('spreadsheet_file', file_path)
  find('input[type="submit"]').click
  sleep 1
end

Then(/^I should see the size of the file$/) do

  file_path = File.expand_path('../../support/fixtures/uploaded_spreadsheet.xlsx', __FILE__)
  size = File.open(file_path, 'r').size
  expect(page.body).to include("Size: #{size}")
end