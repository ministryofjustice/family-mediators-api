module Admin
  module Services
    class ProcessFile

      def initialize(spreadsheet_file,
                     file_validator: Validators::FileValidator,
                     marshaler: Processing::Marshaler,
                     xl_parser: RubyXL::Parser)
        @spreadsheet_file = spreadsheet_file
        @file_validator = file_validator
        @marshaler = marshaler
        @xl_parser = xl_parser
      end

      def call
        raise 'No file specified' unless @spreadsheet_file
        workbook = @xl_parser.parse(file.path)
        data_as_array = Parsers::Workbook.new(workbook).call
        with_expanded_practices = Parsers::MediatorPractices.parse(data_as_array)
        file_validations = @file_validator.new(with_expanded_practices)

        if file_validations.valid?
          [true, {
            file_name: file_name,
            file_size: file.size,
            existing_count: API::Models::Mediator.count,
            sheet_size: data_as_array.size,
            dump: @marshaler.to_string(data_as_array)
          }]
        else
          [false, {
            file_errors: file_validations.errors,
            collection_errors: [],
            item_errors: []
          }]
        end
      end

      private

      def file
        @spreadsheet_file[:tempfile]
      end

      def file_name
        @spreadsheet_file[:filename]
      end
    end
  end
end