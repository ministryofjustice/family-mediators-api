require 'carrierwave/orm/activerecord'
require_relative '../uploaders/asset'

module Admin
  module Models
    class Asset < ActiveRecord::Base
      mount_uploader :file, AssetUploader
    end
  end
end