describe Admin::App do
  include Rack::Test::Methods

  def app
    Admin::App
  end

  context "when healthcheck is called" do
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

  context "when file unsuccessfully uploads" do
    it "redirects to /upload-fail" do
      post "/upload", params: { xlsx_file: nil }, session: { "rack.session" => { "user" => "" } }
      follow_redirect!
      expect(last_request.path).to eq("/upload-fail")
    end
  end

  context "when there is no user session" do
    %w[actions upload upload-success upload-fail].each do |path|
      context "and the GET /#{path} route is called" do
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
      context "when the POST /#{path} route is called" do
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

  context "when the user session is active" do
    %w[actions upload upload-success upload-fail].each do |path|
      context "and the GET /#{path} route is called" do
        it "has 200 status" do
          get "/#{path}", session: { "rack.session" => { "user" => "" } }
          expect(last_response.status).to eq(200)
        end
      end
    end
  end
end
