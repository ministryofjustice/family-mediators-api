require 'spec_helper'

describe Mediators::API do
  include Rack::Test::Methods

  def app
    Mediators::API
  end

  context 'GET /api/v1/mediators' do
    context 'No mediators' do
      it 'returns a list of mediators' do
        get '/api/v1/mediators'
        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body)).to eq []
      end
    end
    context "Some mediators" do
      before do
        create :mediator
      end
      it 'Finds them' do
        get '/api/v1/mediators'
        expect(JSON.parse(last_response.body).size).to eq 1
      end
    end
  end

  context 'GET /api/mediators?postcode=BN2' do
    pending
  end
end
