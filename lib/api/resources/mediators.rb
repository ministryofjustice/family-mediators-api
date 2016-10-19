module API
  class Mediators < Grape::API
    resource :mediators do
      get do
        mediators = Models::Mediator.all
        status 404 if mediators.empty?
        present(
          {
            meta: {
              count: mediators.size
            },
            data: mediators
          }, with: Entities::Collection
        )
      end

      get ':id' do
        mediators = Models::Mediator.where(id: params[:id])

        if mediators.any?
          present mediators.first, with: Entities::Mediator
        else
          status 404
          present({'code' => 'not_found'})
        end
      end
    end
  end
end
