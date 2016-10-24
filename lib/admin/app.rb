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
        file = params[:spreadsheet_file][:tempfile]
        FileProcessor.new(file.path).process

        redirect to "/upload-success?filesize=#{file.size}"

      rescue
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