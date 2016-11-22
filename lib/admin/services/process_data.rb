module Admin
  module Services
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
        sheet_as_array = @marshaler.to_array(@dump)
        data_validations = @data_validator.new(sheet_as_array)

        if data_validations.valid?
          @data_store.save(sheet_as_array)
          [true, {}]
        else
          [false, {
            file_errors: [],
            item_errors: data_validations.item_errors,
            collection_errors: data_validations.collection_errors
          }]
        end
      end
    end
  end
end