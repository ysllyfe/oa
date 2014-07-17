# encoding: utf-8
class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :file
  def store_dir
    "up/#{mounted_as.to_s.underscore}/"
  end
  process :resize_to_limit => [800,800]
  version :t do
    process :resize_to_fill => [30, 30]
  end
  version :s do
    process :resize_to_fill => [50, 50]
  end
  version :m do
    process :resize_to_fill => [100, 100]
  end
  version :b do
    process :resize_to_fill => [200, 200]
  end
  def extension_white_list
    %w(jpg jpeg gif png)
  end
  def filename
    random_token = Time.now.strftime("%Y/%m/") + SecureRandom.hex(5)
    ivar = "@#{mounted_as}_secure_token"    
    token = model.instance_variable_get(ivar)
    token ||= model.instance_variable_set(ivar, random_token)
    "#{token}.#{file.extension}" if original_filename
  end
end