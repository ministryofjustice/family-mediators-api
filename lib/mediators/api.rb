module Mediators
  class API < Grape::API
    prefix :api
    format :json
    version :v1

    resource :mediators do
      get do
        Models::Mediator.all.to_a
      end
    end
  end
end
