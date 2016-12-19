module Admin
  module Processing
    module ConfidentialFieldRemover
      def self.call(records, fields)
        records.map do |record|
          fields.each { |field| record.delete(field) }
          record
        end
      end
    end
  end
end
