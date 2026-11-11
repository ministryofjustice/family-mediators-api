require "spec_helper"

# Automates the manual regression script used to smoke-test a Family Mediator
# API deployment: start page -> login -> upload spreadsheet -> check file
# mediator count -> process -> check success record count -> verify the API.
# Mirrors lib/tasks/regression.rake's live_upload_check, which runs the same
# journey against a real deployed environment.
RSpec.feature "Family Mediator API regression: full upload journey", type: :feature do
  let(:headings) do
    [
      "URN",
      "Title",
      "Last Name",
      "First Name",
      "Practices",
      "Offers Online Mediation",
      "COM",
      "FMA",
      "Law Soc",
      "NFM",
      "Resolution",
      "FMCA Date",
      "Accredited For",
      "Training Date",
      "Trained With",
      "Legal Aid Qualified",
      "Legal Aid Franchise",
      "DCC",
      "PPC",
      "PPC Name",
      "PPC URN",
      "Private Portfolio Submitted",
      "Private Last Re Accreditation Date",
      "Private Next Re Accreditation Date",
      "Private Portfolio Due Date",
      "Private Refresher Cert",
      "Private Notes",
      "Private RTP Date",
      "Private Offers In Person",
      "Private OPIA",
    ]
  end

  let(:confidential_fields) { headings.select { |heading| heading.start_with?("Private ") } }

  let(:mediators) do
    [
      {
        "URN" => "1111A",
        "Title" => "Mr",
        "Last Name" => "Irons",
        "First Name" => "John",
        "Practices" => "15 Smith Street, London WC1R 4RL|01234567890",
        "Offers Online Mediation" => "Yes",
        "COM" => "Yes",
        "FMA" => "No",
        "Law Soc" => "Yes",
        "NFM" => "No",
        "Resolution" => "Yes",
        "FMCA Date" => "01/02/2003",
        "Accredited For" => "Family",
        "Training Date" => "",
        "Trained With" => "ABC Training",
        "Legal Aid Qualified" => "Yes",
        "Legal Aid Franchise" => "No",
        "DCC" => "Yes",
        "PPC" => "Yes",
        "PPC Name" => "",
        "PPC URN" => "",
        "Private Portfolio Submitted" => "Yes",
        "Private Last Re Accreditation Date" => "01/02/2024",
        "Private Next Re Accreditation Date" => "01/02/2026",
        "Private Portfolio Due Date" => "01/01/2026",
        "Private Refresher Cert" => "Yes",
        "Private Notes" => "",
        "Private RTP Date" => "01/02/2024",
        "Private Offers In Person" => "Yes",
        "Private OPIA" => "Yes",
      },
      {
        "URN" => "2222A",
        "Title" => "Mrs",
        "Last Name" => "Wayne",
        "First Name" => "Bruce",
        "Practices" => "",
        "Offers Online Mediation" => "No",
        "COM" => "No",
        "FMA" => "Yes",
        "Law Soc" => "No",
        "NFM" => "Yes",
        "Resolution" => "No",
        "FMCA Date" => "03/04/2005",
        "Accredited For" => "Family",
        "Training Date" => "",
        "Trained With" => "XYZ Training",
        "Legal Aid Qualified" => "No",
        "Legal Aid Franchise" => "Yes",
        "DCC" => "No",
        "PPC" => "No",
        "PPC Name" => "Irons",
        "PPC URN" => "1111A",
        "Private Portfolio Submitted" => "No",
        "Private Last Re Accreditation Date" => "02/03/2024",
        "Private Next Re Accreditation Date" => "02/03/2026",
        "Private Portfolio Due Date" => "02/02/2026",
        "Private Refresher Cert" => "No",
        "Private Notes" => "Flagged for review",
        "Private RTP Date" => "02/03/2024",
        "Private Offers In Person" => "No",
        "Private OPIA" => "No",
      },
      {
        "URN" => "3333A",
        "Title" => "Ms",
        "Last Name" => "Romanova",
        "First Name" => "Natalia",
        "Practices" => "",
        "Offers Online Mediation" => "Yes",
        "COM" => "Yes",
        "FMA" => "Yes",
        "Law Soc" => "Yes",
        "NFM" => "No",
        "Resolution" => "Yes",
        "FMCA Date" => "",
        "Accredited For" => "Family",
        "Training Date" => "05/2022",
        "Trained With" => "ABC Training",
        "Legal Aid Qualified" => "Yes",
        "Legal Aid Franchise" => "Yes",
        "DCC" => "No",
        "PPC" => "No",
        "PPC Name" => "",
        "PPC URN" => "",
        "Private Portfolio Submitted" => "No",
        "Private Last Re Accreditation Date" => "",
        "Private Next Re Accreditation Date" => "",
        "Private Portfolio Due Date" => "",
        "Private Refresher Cert" => "No",
        "Private Notes" => "",
        "Private RTP Date" => "",
        "Private Offers In Person" => "No",
        "Private OPIA" => "No",
      },
    ]
  end

  let(:rows) { mediators.map { |mediator| headings.map { |heading| mediator.fetch(heading) } } }

  it "walks the full upload journey end to end" do
    workbook = TemporaryWorkbook.new(headings, rows, confidential_fields)

    visit "/"
    click_on "Start now"

    expect(page).to have_current_path("/admin/login")
    fill_in "username", with: "username"
    fill_in "password", with: "password"
    click_button "Login"

    expect(page).to have_current_path("/admin/actions")
    click_on "Upload now"

    expect(page).to have_current_path("/admin/upload")
    attach_file("spreadsheet_file", workbook.file_path)
    click_button "Continue"

    expect(page.body).to include("Check file details before processing the excel file")
    expect(page.body).to include("File mediator count: #{rows.size}")
    confidential_fields.each do |field|
      expect(page.body).to include(field.downcase.gsub(" ", "_"))
    end

    click_button "Process data and apply updates"

    expect(page.body).to include("Spreadsheet upload complete")
    expect(page.body).to include("#{rows.size} records successfully written to the database.")

    visit "/api/v1/mediators"
    result = JSON.parse(page.body)
    expect(result["data"].size).to eq(rows.size)
    expect(result["data"].map { |item| item["urn"] }).to contain_exactly("1111A", "2222A", "3333A")
    expect(result["data"].map(&:keys).flatten).not_to include("private_notes", "private_opia")
  end
end
