Given(/^I visit the upload page$/) do
  visit 'http://localhost:9292/admin/hello'
end

Then(/^I should see hello$/) do
  expect(page).to have_content 'hello'
end