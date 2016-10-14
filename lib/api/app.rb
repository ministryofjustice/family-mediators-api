module API
  class App < Grape::API
    prefix :api
    format :json
    version :v1

    resource :mediators do
      get do
        mediators = Models::Mediator.all
        present mediators, with: Entities::Mediator
      end
    end

    resource :healthcheck do
      get do
        {"status":"OKAY"}
      end
    end
  end
end
