require 'spec_helper'


describe MediatorsApi do
  include Rack::Test::Methods

  def app
    MediatorsApi
  end

  context 'GET /api/v1/mediators' do
    it 'returns a list of mediators' do
      get '/api/v1/mediators'
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)).to eq ["hello world"]
    end
  end

  context 'GET /api/mediators?postcode=BN2' do
    pending
  end
  
end