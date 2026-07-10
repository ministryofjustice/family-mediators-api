require "spec_helper"

RSpec.feature "Robots", type: :feature do
  scenario "Web spider looks for /robots.txt" do
    visit "/robots.txt"
    expect(page.body).to include("User-Agent: *")
    expect(page.body).to include("Disallow: /")
  end
end
