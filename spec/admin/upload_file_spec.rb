require 'spec_helper'

require_relative '../../support/helpers/temporary_workbook'

describe Admin::App do
  include Rack::Test::Methods

  let(:parser) { nil }

  def app
    Admin::App.set :parser, parser
  end

  context 'unsuccessfully uploads file' do
    it 'redirects to /upload-fail' do
      post '/upload', { spreadsheet_file: nil }
      follow_redirect!
      expect(last_request.path).to eq '/upload-fail'
    end
  end

end
