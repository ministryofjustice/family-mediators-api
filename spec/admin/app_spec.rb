require 'spec_helper'

describe Admin::App do
  include Rack::Test::Methods

  def app
    Admin::App
  end

  context '/healthcheck' do

    before do
      authorize 'admin', 'admin'
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
      authorize 'admin', 'admin'
      post '/upload', {xlsx_file: nil }
      follow_redirect!
      expect(last_request.path).to eq '/upload-fail'
    end
  end

  context 'test without authentication' do
    it 'has 401 status' do
      get '/'
      expect(last_response.status).to eq(401)
    end
  end

  context 'test with bad credentials' do
    it 'has 401 status' do
      authorize 'bad', 'boy'
      get '/'
      expect(last_response.status).to eq(401)
    end
  end

  context 'test with proper credentials' do
    it 'has 401 status' do
      authorize 'admin', 'admin'
      get '/'
      expect(last_response.status).to eq(200)
    end
  end

end