require 'sinatra/json'

module Admin
  class App < Sinatra::Base

    set :views, File.dirname(__FILE__) + '/../../views'
    set :public_folder, 'public'

    get '/' do
      slim :start
    end

    get '/actions' do
      slim :actions
    end

    get '/upload' do
      slim :index
    end

    get '/healthcheck' do
      json :status => 'OKAY'
    end

    post '/upload' do
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
      success, details = Services::ProcessData.new(params[:dump]).call

      if success
        redirect to('/upload-success')
      else
        slim :data_errors, locals: details
      end
    end

    get '/upload-success' do
      slim :upload_success
    end

    get '/upload-fail' do
      slim :upload_fail
    end
  end
end
