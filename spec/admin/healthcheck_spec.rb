require 'spec_helper'

describe Admin::App do
  include Rack::Test::Methods

  def app
    Admin::App
  end

  it 'has healthcheck path' do
    get '/healthcheck'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq({ status: 'OKAY'}.to_json)
  end

end