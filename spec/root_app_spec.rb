describe RootApp do
  include Rack::Test::Methods

  def app
    RootApp
  end

  context "when GET / routs is called" do
    before do
      get "/"
    end

    it "returns 302" do
      expect(last_response.status).to eq(302)
    end

    it "redirects to /admin page" do
      expect(last_response.location).to eq("http://example.org/admin")
    end
  end

  context "when GET /ping route is called" do
    before do
      get "/ping"
    end

    it "returns 200" do
      expect(last_response.status).to eq(200)
    end

    it "returns a minimal JSON status with no build or infrastructure detail" do
      expect(last_response.body).to eq({ status: "ok" }.to_json)
    end
  end

  context "when GET /deploy_info route is called" do
    before do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with("DEPLOY_DASHBOARD_SHARED_SECRET", nil).and_return("test-secret")
    end

    context "with a valid shared secret" do
      before do
        header "X-Deploy-Dashboard-Secret", "test-secret"
        get "/deploy_info"
      end

      it "returns 200" do
        expect(last_response.status).to eq(200)
      end

      it "returns the build info payload" do
        expect(
          JSON.parse(last_response.body).keys,
        ).to eq(%w[build_date build_tag commit_id])
      end
    end

    context "with an invalid shared secret" do
      before do
        header "X-Deploy-Dashboard-Secret", "wrong-secret"
        get "/deploy_info"
      end

      it "returns 401" do
        expect(last_response.status).to eq(401)
      end
    end

    context "without a shared secret header" do
      before { get "/deploy_info" }

      it "returns 401" do
        expect(last_response.status).to eq(401)
      end
    end
  end

  context "when GET /security.txt route is called" do
    before do
      get "/security.txt"
    end

    it "returns 302" do
      expect(last_response.status).to eq(302)
    end

    it "redirects to the /.well-known/security.txt URL" do
      expect(last_response.location).to eq("http://example.org/.well-known/security.txt")
    end
  end

  context "when GET /.well-known/security.txt route is called" do
    before do
      get "/.well-known/security.txt"
    end

    it "returns 301" do
      expect(last_response.status).to eq(301)
    end

    it "redirects to the MOJ vulnerability disclosure document" do
      expect(last_response.location).to eq("https://raw.githubusercontent.com/ministryofjustice/security-guidance/main/contact/vulnerability-disclosure-security.txt")
    end
  end
end
