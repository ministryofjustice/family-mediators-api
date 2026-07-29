class ContentSecurityPolicy
  POLICY = [
    "default-src 'self'",
    "script-src 'none'",
    "object-src 'none'",
    "form-action 'self'",
    "frame-ancestors 'none'",
    "base-uri 'self'",
  ].join("; ").freeze

  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    headers["Content-Security-Policy"] = POLICY
    [status, headers, body]
  end
end
