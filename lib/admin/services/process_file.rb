module Admin
  module Services

    # Orchestrates reading, parsing, file validation, and marshaling of data if
    # necessary, of an XLSX file.
    class ProcessFile

      def initialize(xlsx_file,
                     file_validator: Validators::FileValidator,
                     marshaler: Processing::Marshaler,
                     xl_parser: RubyXL::Parser)
        @xlsx_file = xlsx_file
        @file_validator = file_validator
        @marshaler = marshaler
        @xl_parser = xl_parser
      end

      def call
        raise 'No file specified' unless @xlsx_file
        rubyxl_workbook = @xl_parser.parse(file.path)
        as_hashes = Parsers::Workbook.new(rubyxl_workbook).call
        file_validations = @file_validator.new(as_hashes)

        if file_validations.valid?
          [ true, valid_locals(as_hashes) ]
        else
          [ false, invalid_locals(file_validations.errors) ]
        end
      end

      private

      def file
        @xlsx_file[:tempfile]
      end

      def file_name
        @xlsx_file[:filename]
      end

      def file_size
        file.size
      end

      def valid_locals(as_hashes)
        {
          file_name: file_name,
          file_size: file_size,
          existing_count: API::Models::Mediator.count,
          sheet_size: as_hashes.size,
          dump: @marshaler.to_string(as_hashes)
        }
      end

      def invalid_locals(errors)
        {
          file_errors: errors,
          collection_errors: [],
          item_errors: []
        }
      end
    end
  end
end