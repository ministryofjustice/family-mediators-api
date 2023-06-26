module Admin
  module Processing
    class DataStore
      def self.save(hashes)
        ActiveRecord::Base.transaction do
          API::Models::Mediator.delete_all
          API::Models::Mediator.create!(with_data_attributes(hashes))
        end
      end

      # Each record has a 'data' attribute which stores the spreadsheet
      # column headings and values as JSON - hence we need to re-map
      # the items with all the keys under the 'data' attribute.
      def self.with_data_attributes(hashes)
        hashes.map do |item|
          { "data" => item }
        end
      end
    end
  end
end
