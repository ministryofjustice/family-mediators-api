require 'sinatra/json'

module Admin
  class App < Sinatra::Base

    configure do
      set :parser, Admin::Parsers::Mediators.new
      set :validator, Admin::Validators::MediatorValidations
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
      handle_upload
    end

    get '/upload-success' do
      slim :upload_success, locals: { size: params[:filesize] }
    end

    get '/upload-fail' do
      slim :upload_fail
    end

    def handle_upload
      begin
        raise 'No file specified' unless params[:spreadsheet_file]
        sheet = spreadsheet(file.path)
        sheet_as_hash = sheet.process
        validations = settings.validator.new(sheet_as_hash)

        if validations.valid?
          sheet.save(sheet_as_hash)
          redirect to "/upload-success?filesize=#{file.size}"
        else
          slim :errors, locals: { item_errors: validations.item_errors, collection_errors: validations.collection_errors }
        end

      rescue => error
        LOGGER.fatal "Failed /upload: #{error.message}"
        redirect to '/upload-fail'
      end
    end

    def file
      params[:spreadsheet_file][:tempfile]
    end

    def spreadsheet(path)
      Processing::Spreadsheet.new(RubyXL::Parser.parse(path), settings.parser)
    end

  end
end
