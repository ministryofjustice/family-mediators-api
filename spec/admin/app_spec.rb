require 'spec_helper'

describe Admin::App do
  include Rack::Test::Methods

  def app
    Admin::App
  end

  context '/healthcheck' do

    before do
      get '/healthcheck'
    end

    it 'has status 200' do
      expect(last_response.status).to eq(200)
    end

    it "has body {status: 'OKAY'}" do
      expect(last_response.body).to eq({ status: 'OKAY'}.to_json)
    end
  end

  context 'unsuccessfully uploads file' do
    it 'redirects to /upload-fail' do
      post '/upload', {xlsx_file: nil }
      follow_redirect!
      expect(last_request.path).to eq '/upload-fail'
    end
  end

end