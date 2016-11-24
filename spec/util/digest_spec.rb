module Util
	describe Digest do
		context '#fingerprint_hash' do
			it 'Fingerprints hashes uniquely' do
			expect(Digest::fingerprint({:a => 1, :b => 2, :c => 3})).not_to eq Digest::fingerprint({:a => 1})
			end
			it 'Fingerprints hash order doesn''t matter' do
				expect(Digest::fingerprint({:a => 1, :b => 2, :c => 3})).to eq Digest::fingerprint({:c => 3, :b => 2, :a => 1})
			end
		end

		context '#deep_structure' do
			it 'Fingerprints deep structure uniquely' do
				expect(Digest::fingerprint({:a => 1, :b => [1, 2, 3], :c => 3})).not_to eq Digest::fingerprint({:a => 1, :b => 1, :c => 3})
			end

			it 'Fingerprints deep array without order' do
				expect(Digest::fingerprint({:a => 1, :b => [1, 2, 3], :c => 3})).to eq Digest::fingerprint({:a => 1, :b => [2, 3, 1], :c => 3})
			end
		end

		context '#types_differ' do
			it 'Fingerprints int and string differently' do
				expect(Digest::fingerprint(1)).not_to eq Digest::fingerprint('1')
			end

			it 'Fingerprints int and float differently' do
				expect(Digest::fingerprint(1)).not_to eq Digest::fingerprint(1.0)
			end

			it 'Fingerprints array and hash differently' do
				expect(Digest::fingerprint([1])).not_to eq Digest::fingerprint(1 => 1)
			end

			it 'Fingerprints int array and int differently' do
				expect(Digest::fingerprint([1])).not_to eq Digest::fingerprint(1)
			end

			it 'Fingerprints float and cast float identically' do
				expect(Digest::fingerprint(1.0)).to eq Digest::fingerprint(Float(1))
			end
		end
	end

	context '#exotic_types_do_not_break' do
		it 'Fingerprints module' do
			expect(Digest::fingerprint(Digest)).not_to eq Digest::fingerprint(Array)
		end
	end
end