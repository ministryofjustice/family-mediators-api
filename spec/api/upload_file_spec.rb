require 'spec_helper'

describe API::App do
  include Rack::Test::Methods

  def app
    API::App
  end

  let(:file_path) { fixture_path 'spreadsheet.xlsx' }

  before do
    post '/api/v1/upload', {
        file: {
          title: 'my first spreadsheet',
          file: Rack::Test::UploadedFile.new(file_path,
                                             'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                                             true)
        }
    }
  end

  it 'uploads a file' do
    expect(last_response.status).to eq(201)
  end

  it 'retrieves the content for the new file' do
    expect(last_response.body).to include('my first spreadsheet')
  end

  it 'retrieves the actual filename' do
    expect(last_response.body).to include('spreadsheet.xlsx')
  end


end