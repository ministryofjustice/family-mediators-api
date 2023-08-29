require 'active_record'

module API
  module Models
    class Mediator < ActiveRecord::Base
      before_create :set_urn_prefix

      def set_urn_prefix
        open(params[:path_or_url])
        self.urn_prefix = data['urn'].to_i
      end
    end
  end
end
