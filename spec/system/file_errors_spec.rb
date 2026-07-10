require "spec_helper"

RSpec.feature "File errors", type: :feature do
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
end
