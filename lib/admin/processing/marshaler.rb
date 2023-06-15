module Admin
  module Processing
    class Marshaler
      def self.to_string(array)
        Base64.encode64(Zlib::Deflate.deflate(array.to_json))
      end

      def self.to_array(string)
        JSON.parse(Zlib::Inflate.inflate(Base64.decode64(string)), { symbolize_names: true })
      end
    end
  end
end
