module Mediators
  module Entities
    class Data < Grape::Entity
      expose :name
      expose :email
    end

    class Mediator < Grape::Entity
      format_with(:iso_timestamp) do |date|
        date.iso8601
      end

      expose :id
      expose :jsonified_data, merge: true

      with_options(format_with: :iso_timestamp) do
        expose :created_at
        expose :updated_at
      end

      def jsonified_data
        JSON.parse object.data
      end
    end
  end
end
