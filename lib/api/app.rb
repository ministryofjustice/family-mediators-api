Dir["#{__dir__}/resources/*.rb"].each do |f|
  require f
end

module API
  class App < Grape::API
    prefix :api
    format :json
    version :v1

    mount ::API::Healthcheck
    mount ::API::Mediators
  end
end
