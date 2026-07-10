require "spec_helper"

RSpec.feature "Data errors", type: :feature do
  def upload_table(rows)
    data_table = DataHelpers::MediatorsDataTable.new(rows)
    with_practice_data = DataHelpers::PracticeData.new(data_table)
    login
    upload_spreadsheet(with_practice_data.headings, with_practice_data.data)
  end

  scenario "Empty spreadsheet shows file error" do
    data_table = DataHelpers::MediatorsDataTable.new([[""]])
    with_practice_data = DataHelpers::PracticeData.new(data_table)
    login
    upload_spreadsheet(with_practice_data.headings, with_practice_data.data)

    expect(get_table_data("#file-errors")).to eq([
      ["Error"],
      ["The file contains no mediator data"],
    ])
  end

  scenario "Mediator data errors" do
    upload_table([
      ["URN", "DCC", "Title", "Last Name", "First Name", "Legal Aid Qualified", "Legal Aid Franchise", "PPC URN", "FMCA Date"],
      ["1234T", "", "Mr", "Irons", "John", "No", "No", "", "27/03/2001"],
      ["3459A", "No", "Mr", "Wayne", "Bruce", "", "No", "", "Blah"],
      ["5436P", "No", "Mr", "Romanova", "Natalia", "No", "", "", "18/2015"],
      ["1948A", "", "Mr", "Kovacs", "", "No", "No", "", "01/02/2013"],
      ["1948A", "No", "", "", "Loki", "No", "No", "", "05/2001"],
    ])
    click_button "Process data and apply updates"

    expect(get_table_data("#item-errors")).to eq([
      ["Row", "Field", "Message"],
      ["2", "dcc", "must be one of: Yes, No"],
      ["3", "legal_aid_qualified", "must be one of: Yes, No"],
      ["3", "fmca_date", "must be dd/mm/yyyy"],
      ["4", "legal_aid_franchise", "must be one of: Yes, No"],
      ["4", "fmca_date", "must be dd/mm/yyyy"],
      ["5", "first_name", "must be filled"],
      ["5", "dcc", "must be one of: Yes, No"],
      ["6", "last_name", "must be filled"],
      ["6", "title", "must be filled"],
    ])
  end

  scenario "Duplicate registration number" do
    upload_table([
      ["URN", "DCC", "Title", "Last Name", "First Name", "Legal Aid Qualified", "PPC URN"],
      ["1234T", "No", "Mrs", "Irons", "John", "No", ""],
      ["1234T", "No", "Mrs", "Wayne", "Bruce", "No", ""],
    ])
    click_button "Process data and apply updates"

    expect(get_table_data("#collection-errors")).to eq([
      ["Error", "Value(s)"],
      ["Duplicate URN", "1234T"],
    ])
  end

  scenario "PPC URN not recognised" do
    upload_table([
      ["URN", "DCC", "Title", "Last Name", "First Name", "Legal Aid Qualified", "PPC URN"],
      ["1234T", "No", "Mr", "Irons", "John", "No", "4567E"],
      ["4567E", "No", "Mr", "Wayne", "Bruce", "No", "5647T"],
      ["8901E", "No", "Mr", "Jon", "Willis", "No", ""],
    ])
    click_button "Process data and apply updates"

    expect(get_table_data("#collection-errors")).to eq([
      ["Error", "Value(s)"],
      ["PPC URN not recognised", "5647T"],
    ])
  end

  scenario "FMCA or Training Date must be present" do
    upload_table([
      ["FMCA Date", "Training Date", "URN", "DCC", "Title", "Last Name", "First Name", "Legal Aid Qualified", "Legal Aid Franchise", "PPC URN"],
      ["", "", "1234T", "Yes", "Mr", "Irons", "John", "No", "No", ""],
    ])
    click_button "Process data and apply updates"

    expect(get_table_data("#item-errors")).to eq([
      ["Row", "Field", "Message"],
      ["2", "training_date", "FMCA Date or Training Date must be present"],
    ])
  end
end
