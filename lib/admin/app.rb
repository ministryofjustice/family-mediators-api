require 'sinatra/json'

module Admin
  class App < Sinatra::Base

    configure do
      set :data_validator, Admin::Validators::MediatorValidations
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

    post '/process' do
      sheet = Processing::Spreadsheet.new
      sheet.load64(params[:dump])
      data_validations = settings.data_validator.new(sheet.to_a)

      if data_validations.valid?
        sheet.save
        redirect to "/upload-success"
      else
        slim :errors, locals: {
          item_errors: data_validations.item_errors,
          collection_errors: data_validations.collection_errors,
          dump: sheet.dump64
        }
      end
    end

    get '/upload-success' do
      slim :upload_success
    end

    get '/upload-fail' do
      slim :upload_fail
    end

    def handle_upload
      begin
        raise 'No file specified' unless params[:spreadsheet_file]
        sheet = Processing::Spreadsheet.new
        sheet.read(file.path)
        # file_validations = settings.file_validator.new(sheet.to_a)
        if 1 == 1 # file_validations.valid?
          slim :overview, locals: {
            file_name: file_name,
            file_size: file.size,
            existing_count: API::Models::Mediator.count,
            sheet: sheet
          }
        else
          slim :file_errors, locals: {
            errors: [ 'all is woe', 'shoot - it is bad' ]
          }
        end

      rescue => error
        LOGGER.fatal "Failed /upload: #{error.message}"
        redirect to '/upload-fail'
      end
    end

    def file
      params[:spreadsheet_file][:tempfile]
    end

    def file_name
      params[:spreadsheet_file][:filename]
    end

  end
end
