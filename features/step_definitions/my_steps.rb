Given(/^I visit the Mediators Admin homepage/) do
  visit 'http://localhost:9292/admin/'
end

Then(/^I should see '(.*)'/) do |text|
  expect(page.body).to include(text)
end