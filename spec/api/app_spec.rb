require 'spec_helper'

describe API::App do
  include Rack::Test::Methods

  def app
    API::App
  end

  context 'GET /api/v1/mediators' do
    context 'No mediators' do
      it 'returns an empty list' do
        get '/v1/mediators'
        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body)).to eq []
      end
    end

    context 'Some mediators' do
      before do
        create :mediator
      end
      it 'returns a list of mediators' do
        get '/v1/mediators'
        expect(JSON.parse(last_response.body).size).to eq 1
      end
    end
  end
end
