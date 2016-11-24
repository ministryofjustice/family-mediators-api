module Util
	class Digest
		include ::Digest

		# returns a unique fingerprint for a data structure as an MD5 hash, useful for quickly checking for changes.
		# Order of hash keys and arrays is assumed to be unimportant for our purposes, and they are treated as sets - i.e., fingerprint([1,2,3]) == fingerprint([3,2,1])
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