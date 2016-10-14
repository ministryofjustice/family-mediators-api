module API
  class UploadFile < Grape::API
    resource :upload do
      post do
        {
            filename: params[:file][:filename],
            size: params[:file][:tempfile].size
        }
      end
    end
  end
end