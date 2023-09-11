module API
  class Healthcheck < Grape::API
    resource :healthcheck do
      get do
        { "status": "OKAY" }
      end
    end
  end
end
