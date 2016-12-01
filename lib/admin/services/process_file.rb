module Admin
  module Services

    # Orchestrates reading, parsing, file validation, and marshaling of data if
    # necessary, of an XLSX file.
    class ProcessFile

      attr_reader :errors

      def initialize(xlsx_path)
        @xlsx_path = xlsx_path
        @errors = []
      end

      def call
        raise 'No file specified' unless @xlsx_path
        rubyxl_workbook = RubyXL::Parser.parse(@xlsx_path)
        mediators_as_hashes, blacklist = Parsers::Workbook.new(rubyxl_workbook).call
        file_validations = Validators::FileValidator.new(mediators_as_hashes, blacklist)

        if file_validations.valid?
          @processed_mediators = Processing::ConfidentialFieldRemover.call(mediators_as_hashes, blacklist)
          true
        else
          # [ false, invalid_locals(file_validations.errors) ]
          @errors = file_validations.errors
          false
        end
      end

      def mediators_count
        @processed_mediators.size
      end

      def dump
        Processing::Marshaler.to_string(@processed_mediators)
      end

    end
  end
end
