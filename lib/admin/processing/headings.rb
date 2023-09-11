module Admin
  module Processing
    class Headings
      def self.process(headings)
        headings.map! { |heading|
          heading ? heading.downcase.gsub(/[^a-z0-9]/, "_").squeeze("_").to_sym : nil
        }.compact
      end
    end
  end
end
