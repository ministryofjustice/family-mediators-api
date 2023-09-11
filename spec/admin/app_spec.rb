describe Admin::App do
  include Rack::Test::Methods

  def app
    Admin::App
  end

  context "/healthcheck" do
    before do
      get "/healthcheck"
    end

    it "has status 200" do
      expect(last_response.status).to eq(200)
    end

    it "has body {status: 'OKAY'}" do
      expect(last_response.body).to eq({ status: "OKAY" }.to_json)
    end
  end

  context "unsuccessfully uploads file" do
    it "redirects to /upload-fail" do
      post "/upload", { xlsx_file: nil }, { "rack.session" => { "user" => "" } } # rubocop:disable Rails/HttpPositionalArguments
      follow_redirect!
      expect(last_request.path).to eq("/upload-fail")
    end
  end

  context "when no user session" do
    %w[actions upload upload-success upload-fail].each do |path|
      context "GET /#{path}" do
        before do
          get "/#{path}"
        end

        it "has 302 status" do
          expect(last_response.status).to eq(302)
        end

        it "redirects to /login" do
          follow_redirect!
          expect(last_request.path).to eq("/login")
        end
      end
    end

    %w[upload upload-process].each do |path|
      context "POST /#{path}" do
        before do
          post "/#{path}"
        end

        it "has 302 status" do
          expect(last_response.status).to eq(302)
        end

        it "redirects to /login" do
          follow_redirect!
          expect(last_request.path).to eq("/login")
        end
      end
    end
  end

  context "when user session active" do
    %w[actions upload upload-success upload-fail].each do |path|
      context "GET /#{path}" do
        it "has 200 status" do
          get "/#{path}", {}, { "rack.session" => { "user" => "" } } # rubocop:disable Rails/HttpPositionalArguments
          expect(last_response.status).to eq(200)
        end
      end
    end
  end
end
