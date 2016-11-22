require 'sinatra/json'

module Admin
  class App < Sinatra::Base

    configure do
      set :file_validator, Admin::Validators::FileValidator
      set :data_validator, Admin::Validators::MediatorValidations
      set :marshaler, Admin::Processing::Marshaler
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

    post '/upload-process' do
      sheet = Processing::Spreadsheet.new()
      sheet_as_array = settings.marshaler.to_array(params[:dump])
      data_validations = settings.data_validator.new(sheet_as_array)

      if data_validations.valid?
        sheet.save(sheet_as_array) # TODO
        redirect to "/upload-success"
      else
        slim :errors, locals: {
          file_errors: [],
          item_errors: data_validations.item_errors,
          collection_errors: data_validations.collection_errors
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
        file_validations = settings.file_validator.new(sheet.to_a)
        if file_validations.valid?
          slim :overview, locals: {
            file_name: file_name,
            file_size: file.size,
            existing_count: API::Models::Mediator.count,
            sheet_size: sheet.to_a.size,
            dump: settings.marshaler.to_string(sheet.to_a)
          }
        else
          slim :errors, locals: {
            file_errors: file_validations.errors,
            collection_errors: [],
            item_errors: []
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
