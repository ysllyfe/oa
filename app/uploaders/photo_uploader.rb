# encoding: utf-8
class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  #storage :aliyun
  storage :file

  def store_dir
    "up/staff/"
  end

  version :s do
    process :resize_to_fit => [100, 100]
  end

  version :m do
    process :resize_to_fit => [200, 200]
  end

  version :b do
    process :resize_to_fit => [500, 500]
  end


  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename
    #random_token = Digest::SHA2.hexdigest("#{Time.now.utc}--#{model.id.to_s}").first(20)
    random_token = Time.now.strftime("%Y/%m/") + SecureRandom.hex(5)
    ivar = "@#{mounted_as}_secure_token"    
    token = model.instance_variable_get(ivar)
    token ||= model.instance_variable_set(ivar, random_token)
    "#{token}.#{file.extension}" if original_filename
  end
end