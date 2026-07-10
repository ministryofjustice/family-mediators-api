require "spec_helper"

RSpec.feature "Upload success", type: :feature do
  def upload_table(rows)
    data_table = DataHelpers::MediatorsDataTable.new(rows)
    with_practice_data = DataHelpers::PracticeData.new(data_table)
    login
    upload_spreadsheet(with_practice_data.headings, with_practice_data.data)
  end

  scenario "Upload file successfully" do
    upload_table([
      ["URN", "DCC", "Title", "Last Name", "First Name", "Legal Aid Qualified", "Legal Aid Franchise", "PPC URN", "FMCA Date"],
      ["1234T", "Yes", "Mr", "Irons", "John", "Yes", "No", "", "01/02/2003"],
      ["3456T", "No", "Mr", "Irons", "John", "No", "Yes", "", "01/02/2003"],
    ])
    expect(page.body).to include("Check file details before processing the excel file")
    click_button "Process data and apply updates"
    expect(page.body).to include("Spreadsheet upload complete")

    visit "/api/v1/mediators"
    result = JSON.parse(page.body)
    expect(result["data"].count).to eq(2)
    expect(result["data"].map { |item| item["id"] }).to eq([1234, 3456])

    visit "/api/v1/mediators/1234"
    expect(JSON.parse(page.body)["urn"]).to eq("1234T")
  end

  scenario "Delete previous records" do
    10.times { |i| API::Models::Mediator.create(data: { "urn" => "#{1000 + i + 1}T" }) }

    visit "/api/v1/mediators"
    expect(JSON.parse(page.body)["data"].count).to eq(10)

    upload_table([
      ["URN", "DCC", "Title", "Last Name", "First Name", "Legal Aid Qualified", "Legal Aid Franchise", "PPC URN", "FMCA Date"],
      ["1234T", "No", "Mr", "Irons", "John", "No", "Yes", "", "01/02/2003"],
      ["3456T", "Yes", "Mr", "Irons", "John", "Yes", "No", "", "01/02/2003"],
    ])
    expect(page.body).to include("Check file details before processing the excel file")
    click_button "Process data and apply updates"

    visit "/api/v1/mediators"
    expect(JSON.parse(page.body)["data"].count).to eq(2)
  end

  scenario "With a blacklist" do
    rows = [
      ["URN", "DCC", "Title", "Last Name", "First Name", "Legal Aid Qualified", "Legal Aid Franchise", "PPC URN", "FMCA Date", "Secret1", "Secret2"],
      ["1234T", "Yes", "Mr", "Irons", "John", "Yes", "Yes", "", "01/02/2003", "41", "42"],
      ["3456T", "Yes", "Mr", "Irons", "John", "Yes", "Yes", "", "01/02/2003", "42", "43"],
    ]
    data_table = DataHelpers::MediatorsDataTable.new(rows)
    with_practice_data = DataHelpers::PracticeData.new(data_table)
    blacklist = %w[Secret1 Secret2]
    login
    upload_spreadsheet(with_practice_data.headings, with_practice_data.data, blacklist)

    expect(page.body).to include("urn")
    expect(page.body).to include("secret1")
    expect(page.body).to include("Check file details before processing the excel file")
    click_button "Process data and apply updates"
    expect(page.body).to include("Spreadsheet upload complete")

    visit "/api/v1/mediators"
    expect(page.body).to include("urn")
    expect(page.body).not_to include("secret1")
    expect(page.body).not_to include("secret2")
  end
end
