require 'sinatra/base'

module Admin
  class App < Sinatra::Base

    get '/hello' do
      'hello'
    end

    post '/upload' do
      status 201
      asset = Models::Asset.new params[:file]
      asset.save
      asset.inspect
    end

  end
end