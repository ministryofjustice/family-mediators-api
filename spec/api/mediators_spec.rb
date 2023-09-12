describe API::App do # rubocop:disable RSpec/FilePath
  include Rack::Test::Methods

  def app
    API::App
  end

  context "when GET /api/v1/mediators route called" do
    context "and there are no mediators" do
      before { get "/v1/mediators" }

      it "returns 404" do
        expect(last_response.status).to eq 404
      end

      context "when response body is rendered" do
        subject(:response_body) { JSON.parse(last_response.body) }

        it "return meta count of zero" do
          expect(response_body["meta"]["count"]).to eq 0
        end

        it "returns an empty data list" do
          expect(response_body["data"]).to eq []
        end
      end
    end

    context "when there are some mediators" do
      before do
        create :mediator
        get "/v1/mediators"
      end

      it "returns 200" do
        expect(last_response.status).to eq 200
      end

      context "when response body is rendered" do
        subject(:response_body) { JSON.parse(last_response.body) }

        it { is_expected.to include("meta") }
        it { is_expected.to include("data") }

        it "returns an array of mediators" do
          expect(response_body["data"].size).to eq(1)
        end
      end
    end
  end

  context "when GET /api/v1/mediators/{id} route is called" do
    context "and the id is not found" do
      before { get "/v1/mediators/6789" }

      it "returns 404" do
        expect(last_response.status).to eq 404
      end

      it "presents an error" do
        expect(JSON.parse(last_response.body)["code"]).to eq "not_found"
      end
    end

    context "when found" do
      let(:mediator) { create :mediator }

      before { get "/v1/mediators/#{mediator.urn_prefix}" }

      it "returns 200" do
        expect(last_response.status).to eq 200
      end

      it "returns the mediator" do
        expect(JSON.parse(last_response.body)["id"]).to eq mediator.urn_prefix
      end
    end
  end
end
