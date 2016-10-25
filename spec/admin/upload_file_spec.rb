require 'spec_helper'

describe Admin::App do
  include Rack::Test::Methods

  def app
    Admin::App
  end

  let(:file_path) { fixture_path 'spreadsheet.xlsx' }

  context 'successfully uploads file' do
    it 'redirects to /upload-success' do
      post '/upload', {
        spreadsheet_file: Rack::Test::UploadedFile.new(
          file_path,
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
          true
        )
      }
      expect(last_response.redirect?).to be true
      follow_redirect!
      expect(last_request.path).to eq '/upload-success'
    end
  end

  context 'unsuccessfully uploads file' do
    it 'redirects to /upload-fail' do
      post '/upload', { spreadsheet_file: nil }
      follow_redirect!
      expect(last_request.path).to eq '/upload-fail'
    end
  end

end
