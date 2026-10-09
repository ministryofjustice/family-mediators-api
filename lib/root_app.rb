class RootApp < Sinatra::Base
  BUILD_ARGS = {
    build_date: ENV["APP_BUILD_DATE"],
    build_tag: ENV["APP_BUILD_TAG"],
    commit_id: ENV["APP_GIT_COMMIT"],
  }.freeze

  set :public_folder, "public"

  get "/" do
    redirect "/admin"
  end

  get %r{/ping(\.json)?} do
    content_type :json
    { status: "ok" }.to_json
  end

  get %r{/deploy_info(\.json)?} do
    authenticate_deploy_dashboard!
    content_type :json
    BUILD_ARGS.to_json
  end

  get "/security.txt" do
    redirect "/.well-known/security.txt"
  end

  get "/.well-known/security.txt" do
    redirect "https://raw.githubusercontent.com/ministryofjustice/security-guidance/main/contact/vulnerability-disclosure-security.txt", 301
  end

  helpers do
    def authenticate_deploy_dashboard!
      expected_secret = ENV.fetch("DEPLOY_DASHBOARD_SHARED_SECRET", nil)
      provided_secret = request.env["HTTP_X_DEPLOY_DASHBOARD_SECRET"]

      return if expected_secret && !expected_secret.empty? &&
        provided_secret && !provided_secret.empty? &&
        Rack::Utils.secure_compare(provided_secret, expected_secret)

      halt 401
    end
  end
end
