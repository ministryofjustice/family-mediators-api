module Mediators
  module Models
    class Mediator
      include Mongoid::Document
      include Mongoid::Timestamps

      field :name, type: String
      field :email, type: String
      field :phone, type: String
      field :website, type: String

      # tags and comments will be stored inside the
      # Post document
      #embeds_many :practices
      #embeds_many :qualifications

      #scope :ordered, -> { order('name') }
    end
  end
end
