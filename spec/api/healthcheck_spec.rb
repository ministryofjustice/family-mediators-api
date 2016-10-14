require 'spec_helper'

describe API::App do
  include Rack::Test::Methods

  def app
    API::App
  end

  it 'has healthcheck path' do
    get 'api/v1/healthcheck'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq({ status: 'OKAY'}.to_json)
  end


end