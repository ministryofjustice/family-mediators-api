class RootApp < Sinatra::Base
  BUILD_ARGS = {
    build_date: ENV["BUILD_DATE"],
    build_tag: ENV["BUILD_TAG"],
    commit_id: ENV["GIT_COMMIT"],
  }.freeze

  set :public_folder, "public"

  get "/" do
    redirect "/admin"
  end

  get %r{/ping(\.json)?} do
    content_type :json
    BUILD_ARGS.to_json
  end

  get "/security.txt" do
    redirect "/.well-known/security.txt"
  end

  get "/.well-known/security.txt" do
    redirect "https://raw.githubusercontent.com/ministryofjustice/security-guidance/main/contact/vulnerability-disclosure-security.txt", 301
  end
end
