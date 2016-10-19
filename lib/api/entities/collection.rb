module API
  module Entities
    class Collection < Grape::Entity
      expose :meta, using: Meta
      expose :data, using: Mediator
    end
  end
end
