require 'spec_helper'

describe Admin::App do
  include Rack::Test::Methods

  def app
    Admin::App
  end

  let(:file_path) { fixture_path 'spreadsheet.xlsx' }

  it 'uploads a file' do
    post '/upload', {
        file: {
            title: 'spreadsheet123',
            file: Rack::Test::UploadedFile.new(file_path,
                                               'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                                               true)
        }
    }
    expect(last_response.status).to eq(201)
  end

end