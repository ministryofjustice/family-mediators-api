def delete_uploads
  upload_dir = File.expand_path('../../../public/uploads', __FILE__)
  Dir["#{upload_dir}/*"].each do |file|
    File.delete file
  end
end