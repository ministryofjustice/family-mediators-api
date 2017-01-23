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
        @workbook = nil
      end

      def call
        raise 'No file specified' unless @xlsx_path
        rubyxl_workbook = RubyXL::Parser.parse(@xlsx_path)
        @workbook = Parsers::Workbook.new(rubyxl_workbook)
        file_validations = Validators::FileValidator.new(
          workbook_mediators, workbook_blacklist)

        if file_validations.valid?
          @processed_mediators = Processing::ConfidentialFieldRemover.call(
            workbook_mediators, workbook_blacklist)
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

      private

      def workbook_blacklist
        @workbook.blacklist
      end

      def workbook_mediators
        @workbook.mediators
      end

    end
  end
end
