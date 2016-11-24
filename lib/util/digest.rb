module Util
	class Digest
		include ::Digest

		def self.fingerprint(struct)
			::Digest::MD5.hexdigest( _build_fingerprint struct )
		end

		def self._build_fingerprint(struct)
			if struct.class == Hash
				arr = []
				struct.each do |key, value|
					arr << "#{_build_fingerprint key}=>#{_build_fingerprint value}"
				end
				struct = arr
			end
			if struct.class == Array
				str = ''
				struct.map! do |value|
					_build_fingerprint value
				end.sort!.each do |value|
					str << value
				end
			end
			if struct.class != String
				struct = struct.to_s << struct.class.to_s
			end
			struct
		end

		private_class_method :_build_fingerprint
  end
end