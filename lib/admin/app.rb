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
      if params[:spreadsheet_file] && params[:spreadsheet_file][:filename]
        filename = params[:spreadsheet_file][:filename]
        file = params[:spreadsheet_file][:tempfile]
        path = "./public/uploads/#{filename}"

        File.open(path, 'wb') do |f|
          f.write(file.read)
        end

        redirect to "/upload-success?filename=#{filename}"
      end

      redirect to '/upload-fail'

    end

    get '/upload-success' do
      path = "./public/uploads/#{params[:filename]}"
      file = File.open(path, 'r')
      slim :upload_success, locals: { size: file.size }
    end

    get '/upload-fail' do
      slim :upload_fail
    end

  end
end