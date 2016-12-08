require 'sinatra/json'

module Admin
  class App < Sinatra::Base

    # use Rack::Auth::Basic do |username, password|
    #   username == 'admin' and password == 'admin'
    # end

    TEN_MINUTES   = 60 * 10
    use Rack::Session::Pool, expire_after: TEN_MINUTES # Expire sessions after ten minutes of inactivity
    helpers Helpers

    set :views, File.dirname(__FILE__) + '/../../views'
    set :public_folder, 'public'

    get '/login' do
      slim :login
    end

    post '/login' do
      if user = User.authenticate(params)
        session[:user] = user
        redirect_to_original_request
      else
        redirect url('/login?incorrect=true')
      end
    end

    get '/' do
      slim :start
    end

    get '/actions' do
      authenticate!
      slim :actions
    end

    get '/upload' do
      authenticate!
      slim :index
    end

    get '/healthcheck' do
      authenticate!
      json :status => 'OKAY'
    end

    post '/upload' do
      authenticate!
      begin
        success, details = Services::ProcessFile.new(
          params[:spreadsheet_file]
        ).call

        if success
          slim :overview, locals: details
        else
          slim :file_errors, locals: details
        end

      rescue => error
        LOGGER.fatal "Failed /upload: #{error.message}"
        redirect to('/upload-fail')
      end
    end

    post '/upload-process' do
      authenticate!
      success, details = Services::ProcessData.new(params[:dump]).call

      if success
        redirect to('/upload-success')
      else
        slim :data_errors, locals: details
      end
    end

    get '/upload-success' do
      authenticate!
      slim :upload_success
    end

    get '/upload-fail' do
      authenticate!
      slim :upload_fail
    end
  end
end
