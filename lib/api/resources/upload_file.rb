module API
  class UploadFile < Grape::API
    resource :upload do
      post do
        # require 'pry';binding.pry;

        asset = Models::Asset.new params[:file]
        asset.save
        asset.inspect
      end
    end
  end
end