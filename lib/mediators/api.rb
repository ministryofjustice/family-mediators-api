module Mediators
  class API < Grape::API
    prefix :api
    format :json
    version :v1

    resource :mediators do
      get do
        mediators = Models::Mediator.all
        present mediators, with: Mediators::Entities::Mediator
      end
    end
  end
end
