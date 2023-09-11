require "sinatra/json"
require "securerandom"

module Admin
  class App < Sinatra::Base
    use Rack::Session::Cookie,
        key: "_fma_session",
        expire_after: 600,  # 10 minutes
        secret: ENV.fetch("SESSION_SECRET") { SecureRandom.hex(64) }

    helpers Helpers

    set :views, File.dirname(__FILE__) + "/../../views"
    set :public_folder, "public"

    get "/login" do
      slim :login
    end

    post "/login" do
      if (user = Admin::User.authenticate(params))
        session[:user] = user
        redirect_to_original_request
      else
        redirect url("/login?incorrect=true")
      end
    end

    get "" do
      redirect "admin/", 302
    end

    get "/" do
      slim :start
    end

    get "/healthcheck" do
      json status: "OKAY"
    end

    get "/actions" do
      authenticate!
      slim :actions
    end

    get "/upload" do
      authenticate!
      slim :index
    end

    post "/upload" do
      authenticate!
      begin
        file = params[:spreadsheet_file]
        process_file = Services::ProcessFile.new(file[:tempfile].path)

        if process_file.call
          slim :overview, locals: {
            file_name: file[:filename],
            file_size: file[:tempfile].size,
            existing_count: API::Models::Mediator.count,
            sheet_size: process_file.mediators_count,
            confidential_fields: process_file.confidential_fields,
            public_fields: process_file.public_fields,
            dump: process_file.dump,
          }
        else
          slim :file_errors, locals: {
            file_errors: process_file.errors,
            collection_errors: [],
            item_errors: [],
          }
        end
      rescue StandardError => e
        LOGGER.fatal "Failed /upload: #{e.message}"
        redirect to("/upload-fail")
      end
    end

    post "/upload-process" do
      authenticate!
      success, details = Services::ProcessData.new(params[:dump]).call

      if success
        redirect to("/upload-success")
      else
        slim :data_errors, locals: details
      end
    end

    get "/upload-success" do
      authenticate!
      slim :upload_success
    end

    get "/upload-fail" do
      authenticate!
      slim :upload_fail
    end
  end
end
