describe RootApp do
  include Rack::Test::Methods

  def app
    RootApp
  end

  context 'GET /' do
    before do
      get '/'
    end

    it 'returns 302' do
      expect(last_response.status).to eq(302)
    end

    it 'redirects to /admin page' do
      expect(last_response.location).to eq('http://example.org/admin')
    end
  end

  context 'GET /ping.json' do
    before do
      get '/ping.json'
    end

    it 'returns 200' do
      expect(last_response.status).to eq(200)
    end

    it 'returns the expected payload' do
      expect(
        JSON.parse(last_response.body).keys
      ).to eq(%w(build_date build_tag commit_id))
    end
  end
end
