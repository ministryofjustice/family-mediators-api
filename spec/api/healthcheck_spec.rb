describe API::App do # rubocop:disable RSpec/SpecFilePathFormat
  include Rack::Test::Methods

  def app
    API::App
  end

  context "when GET /v1/healthcheck route called" do
    before do
      get "/v1/healthcheck"
    end

    it "returns 200" do
      expect(last_response.status).to eq(200)
    end

    it "returns status OKAY message" do
      expect(JSON.parse(last_response.body)["status"]).to eq("OKAY")
    end
  end
end
