require 'sinatra/json'

module Admin
  class App < Sinatra::Base

    configure do
      set :parser, Admin::Parsers::Mediators.new
    end

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
        raise "No file specified" unless params[:spreadsheet_file]

        file = params[:spreadsheet_file][:tempfile]
        Processing::Spreadsheet.new(file.path, settings.parser).process

        redirect to "/upload-success?filesize=#{file.size}"

      rescue => e
        LOGGER.fatal "Failed /upload: #{e.message}"
        redirect to '/upload-fail'
      end
    end

    get '/upload-success' do
      slim :upload_success, locals: { size: params[:filesize] }
    end

    get '/upload-fail' do
      slim :upload_fail
    end

  end
end
