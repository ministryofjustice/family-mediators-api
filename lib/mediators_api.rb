require 'grape'

class MediatorsApi < Grape::API
    prefix :api
    format :json
    version :v1

    resource :mediators do
        get do
            ["hello world"]
        end
    end
end
