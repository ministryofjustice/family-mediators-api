require 'spec_helper'

describe API::App do
  include Rack::Test::Methods

  def app
    API::App
  end

  context 'GET /api/v1/mediators' do
    context 'No mediators' do
      before { get '/v1/mediators' }

      it 'returns 404' do
        expect(last_response.status).to eq 404
      end

      it 'return meta count of zero' do
        expect(JSON.parse(last_response.body)['meta']['count']).to eq 0
      end

      it 'returns an empty data list' do
        expect(JSON.parse(last_response.body)['data']).to eq []
      end
    end

    context 'Some mediators' do
      before do
        create :mediator
        get '/v1/mediators'
      end

      it 'returns 200' do
        expect(last_response.status).to eq 200
      end

      it 'has a meta member' do
        expect(JSON.parse(last_response.body)).to include 'meta'
      end

      it 'has a data member' do
        expect(JSON.parse(last_response.body)).to include 'data'
      end

      it 'returns a list of mediators' do
        expect(JSON.parse(last_response.body)['data'].size).to eq 1
      end
    end
  end

  context 'GET /api/v1/mediators/{id}' do
    context 'Not found' do
      before { get "/v1/mediators/6789" }

      it 'returns 404' do
        expect(last_response.status).to eq 404
      end

      it 'presents an error' do
        expect(JSON.parse(last_response.body)['code']).to eq 'not_found'
      end
    end

    context 'Found' do
      let(:mediator) { create :mediator }
      before { get "/v1/mediators/#{mediator.id}" }

      it 'returns 200' do
        expect(last_response.status).to eq 200
      end

      it 'returns the mediator' do
        expect(JSON.parse(last_response.body)['id']).to eq mediator.id
      end
    end
  end
end
