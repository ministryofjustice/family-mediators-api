require "active_record"

module API
  module Models
    class Mediator < ActiveRecord::Base # rubocop:disable Rais/ApplicationRecord
      before_create :set_urn_prefix

      def set_urn_prefix
        self.urn_prefix = data["urn"].to_i
      end
    end
  end
end
