require "content_security_policy"

describe ContentSecurityPolicy do
  include Rack::Test::Methods

  let(:inner_app) { ->(_env) { [200, {}, %w[OK]] } }

  def app
    ContentSecurityPolicy.new(inner_app)
  end

  before { get "/" }

  it "sets the Content-Security-Policy header" do
    expect(last_response.headers["Content-Security-Policy"]).to eq(ContentSecurityPolicy::POLICY)
  end

  it "includes default-src 'self'" do
    expect(last_response.headers["Content-Security-Policy"]).to include("default-src 'self'")
  end

  it "blocks scripts" do
    expect(last_response.headers["Content-Security-Policy"]).to include("script-src 'none'")
  end

  it "blocks object embeds" do
    expect(last_response.headers["Content-Security-Policy"]).to include("object-src 'none'")
  end

  it "restricts form actions to self" do
    expect(last_response.headers["Content-Security-Policy"]).to include("form-action 'self'")
  end

  it "prevents framing" do
    expect(last_response.headers["Content-Security-Policy"]).to include("frame-ancestors 'none'")
  end

  it "restricts base URI to self" do
    expect(last_response.headers["Content-Security-Policy"]).to include("base-uri 'self'")
  end

  it "passes the response through unchanged" do
    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq("OK")
  end
end
