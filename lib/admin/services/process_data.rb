require 'pry-byebug'

module Admin
  module Services

    # Orchestrates un-marshaling, expanding practices, validation and
    # saving if successful, of mediator hashes.
    class ProcessData

      def initialize(dump,
                     marshaler: Processing::Marshaler,
                     data_validator: Validators::MediatorValidations,
                     data_store: Processing::DataStore)
        @dump = dump
        @marshaler = marshaler
        @data_validator = data_validator
        @data_store = data_store
      end

      def call
        binding.pry
        as_hashes = @marshaler.to_array(@dump)
        data_validations = @data_validator.new(as_hashes)

        if data_validations.valid?
          @data_store.save(as_hashes)
          [ true, {} ]
        else
          [ false, invalid_locals(data_validations) ]
        end
      end

      private

      def invalid_locals(data_validations)
        {
          file_errors: [],
          item_errors: data_validations.item_errors,
          collection_errors: data_validations.collection_errors
        }
      end
    end
  end
end
