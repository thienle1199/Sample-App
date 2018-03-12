class PictureUploader < CarrierWave::Uploader::Base
    storage :dropbox
    include CarrierWave::MiniMagick
    process resize_to_limit: [400, 400]
  # Choose what kind of storage to use for this uploader:

    


  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end


  def extension_whitelist
    %w(jpg jpeg gif png)
  end
end
