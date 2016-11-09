require 'sinatra/json'

module Admin
  class App < Sinatra::Base

    configure do
      set :parser, Admin::Parsers::Mediators.new
      set :validator, Admin::Validators::Mediators
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
        raise 'No file specified' unless params[:spreadsheet_file]
        file = params[:spreadsheet_file][:tempfile]

        spreadsheet = Processing::Spreadsheet.new(RubyXL::Parser.parse(file.path), settings.parser)
        processed_data = spreadsheet.process
        validator = settings.validator.new(processed_data)
        valid = validator.validate

        if valid
          spreadsheet.save(processed_data)
          redirect to "/upload-success?filesize=#{file.size}"
        else
          slim :errors, locals: { errors: validator.errors }
        end

      rescue => error
        LOGGER.fatal "Failed /upload: #{error.message}"
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
