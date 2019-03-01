class RootApp < Sinatra::Base
  BUILD_ARGS = {
    version_number: ENV['APP_VERSION'],
    build_date: ENV['APP_BUILD_DATE'],
    commit_id: ENV['APP_GIT_COMMIT'],
    build_tag: ENV['APP_BUILD_TAG'],
  }.freeze

  set :public_folder, 'public'

  get '/' do
    redirect '/admin'
  end

  get '/ping.json' do
    content_type :json
    BUILD_ARGS.to_json
  end
end
