class AssetUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "public/uploads/assets/#{model.id}"
  end
end