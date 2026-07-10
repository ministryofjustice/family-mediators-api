require "spec_helper"

RSpec.feature "Authentication", type: :feature do
  scenario "Redirect user to originally requested page after logging in" do
    visit "/admin/upload"
    expect(page).to have_current_path("/admin/login")
    fill_in "username", with: "username"
    fill_in "password", with: "password"
    click_button "Login"
    expect(page).to have_current_path("/admin/upload")
  end
end
