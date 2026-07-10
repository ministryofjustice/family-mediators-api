require "spec_helper"

RSpec.feature "Practice data", type: :feature do
  def upload_with_practice(practice_data)
    data_table = DataHelpers::MediatorsDataTable.create_mediator
    with_practice_data = DataHelpers::PracticeData.new(data_table, practice_data:)
    login
    upload_spreadsheet(with_practice_data.headings, with_practice_data.data)
    click_button "Process data and apply updates"
  end

  scenario "Invalid telephone number" do
    upload_with_practice("071 23358|15 Smith Street, London WC1R 4RL")
    expect(page).to have_css("#item-errors tbody td", text: "Practice 1: Must be valid UK phone number")
  end

  scenario "Invalid URL" do
    upload_with_practice("15 Smith Street, London WC1R 4RL | www.smith.com")
    expect(page).to have_css("#item-errors tbody td", text: "Practice 1: Must be valid URL")
  end

  scenario "Invalid email" do
    upload_with_practice("15 Smith Street, London WC1R 4RL | invalid@@email")
    expect(page).to have_css("#item-errors tbody td", text: "Practice 1: Must be valid email address")
  end
end
