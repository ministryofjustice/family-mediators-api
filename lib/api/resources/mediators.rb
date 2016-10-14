module API
  class Mediators < Grape::API
    resource :mediators do
      get do
        mediators = Models::Mediator.all
        present mediators, with: Entities::Mediator
      end
    end
  end
end