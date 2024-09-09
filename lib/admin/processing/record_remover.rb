module Admin
  module Processing
    class RecordRemover
      def initialize(records)
        @records = records
      end

      def call
        @records = remove_blank_records
        @records = remove_students
        @records
      end

    private

      def remove_blank_records
        @records.each_with_object([]) do |record, compacted|
          compacted << record unless all_values_blank?(record)
        end
      end

      def all_values_blank?(record)
        record.values.all? { |val| (val && val.empty?) || val.nil? }
      end

      def remove_students
        @records.each_with_object([]) do |record, without_students|
          without_students << record unless is_student?(record)
        end
      end

      def is_student?(record)
        record[:urn]&.last == "S"
      end
    end
  end
end
