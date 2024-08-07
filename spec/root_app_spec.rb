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

    it "returns the expected payload" do
      expect(
        JSON.parse(last_response.body).keys,
      ).to eq(%w[build_date build_tag commit_id])
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
