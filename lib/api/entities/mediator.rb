module API
  module Entities
    class Mediator < Grape::Entity
      format_with(:iso_timestamp) do |date|
        date.iso8601
      end

      expose :urn_prefix, as: 'id'
      expose :data, merge: true

      with_options(format_with: :iso_timestamp) do
        expose :created_at, as: 'createdAt'
        expose :updated_at, as: 'updatedAt'
      end
    end
  end
end
