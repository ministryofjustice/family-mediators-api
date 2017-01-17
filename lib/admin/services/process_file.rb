module Admin
  module Services

    # Orchestrates reading, parsing, file validation, and marshaling of data if
    # necessary, of an XLSX file.
    class ProcessFile

      attr_reader :errors

      def initialize(xlsx_path)
        @xlsx_path = xlsx_path
        @errors = []
        @processed_mediators = []
      end

      def call
        raise 'No file specified' unless @xlsx_path
        rubyxl_workbook = RubyXL::Parser.parse(@xlsx_path)
        @workbook = Parsers::Workbook.new(rubyxl_workbook)
        file_validations = Validators::FileValidator.new(
          @workbook.mediators, @workbook.blacklist)

        if file_validations.valid?
          @processed_mediators = Processing::ConfidentialFieldRemover.call(
            @workbook.mediators, @workbook.blacklist)
          true
        else
          @errors = file_validations.errors
          false
        end
      end

      def warnings
        @workbook.warnings
      end

      def mediators_count
        @processed_mediators.size
      end

      def dump
        Processing::Marshaler.to_string(@processed_mediators)
      end

      def confidential_fields
        @workbook.blacklist
      end

      def public_fields
        @processed_mediators.any? ? @processed_mediators.first.keys : []
      end

    end
  end
end
