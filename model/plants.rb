require 'active_record'
require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'mini_magick'

class PlantImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  version :thumb do
    process :resize_to_fill => [200,200]
  end

  def store_dir
    'uploaded'
  end

  # storage :file
end

class Plant < ActiveRecord::Base
	mount_uploader :image, PlantImageUploader
end

