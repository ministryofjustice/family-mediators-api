module Admin
  module Processing
    class Headings
      def self.process(headings)
        headings.map! do |heading|
          heading ? heading.downcase.gsub(/[^a-z0-9]/, '_').squeeze('_').to_sym : nil
        end.compact
      end
    end
  end
end
