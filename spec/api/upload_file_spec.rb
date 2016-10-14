require 'spec_helper'

describe API::App do
  include Rack::Test::Methods

  def app
    API::App
  end

  it 'uploads a file' do

    file_path = fixture_path 'spreadsheet.xlsx'

    post '/api/v1/upload', {
        file: Rack::Test::UploadedFile.new(file_path,
             'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
             true)
    }

    expect(last_response.status).to eq(201)
    expect(last_response.body).to eq({
                                         'filename' => 'spreadsheet.xlsx',
                                         'size' => File.size(file_path)
                                     }.to_json)

  end
end