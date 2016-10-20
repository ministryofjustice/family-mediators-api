require 'sinatra/json'

module Admin
  class App < Sinatra::Base

    set :views, File.dirname(__FILE__) + '/../../views'

    get '/' do
      slim :index
    end

    get '/healthcheck' do
      json :status => 'OKAY'
    end

    post '/upload' do
      status 201
      asset = Models::Asset.new params[:file]
      asset.save
      asset.inspect
    end

  end
end