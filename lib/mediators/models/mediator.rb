module Mediators
  module Models
    class Mediator
      include Mongoid::Document
      include Mongoid::Timestamps

      field :name, type: String
      field :email, type: String
      field :phone, type: String
      field :website, type: String
    end
  end
end
