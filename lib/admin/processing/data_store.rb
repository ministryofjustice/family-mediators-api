module Admin
  module Processing
    class DataStore

      def self.save(array)
        with_data_attributes = array.map { |item| {'data' => item} }

        ActiveRecord::Base.transaction do
          API::Models::Mediator.delete_all
          API::Models::Mediator.create(with_data_attributes)
        end
      end

    end
  end
end
