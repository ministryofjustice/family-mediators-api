require 'sinatra/json'

module Admin
  class App < Sinatra::Base

    set :views, File.dirname(__FILE__) + '/../../views'

    get '/' do
      slim :index
    end

    get '/healthcheck' do
      json :status => 'OKAY'
    end

    post '/upload' do
      begin
        raise "No file specified" unless params[:spreadsheet_file]
        
        file = params[:spreadsheet_file][:tempfile]
        SpreadsheetProcessor.new(file.path).process

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
