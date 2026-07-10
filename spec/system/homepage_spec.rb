require "spec_helper"

RSpec.feature "Homepage", type: :feature do
  scenario "Visiting / redirects to admin homepage" do
    visit "/"
    expect(page).to have_current_path("/admin/")
  end
end
