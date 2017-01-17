module Admin
  module Parsers

    describe Practice do
      let(:address)  { '1 Null Way, Wessex, BN20GB' }
      let(:tel)      { '012345-909090' }
      let(:email)    { 'foo@bar.com' }
      let(:url)      { 'http://foo.com/bar' }
      let(:practice) { [address, tel, email, url].join(' | ') }
      let(:unparsed) { [practice, practice, practice].join("\n") }

      let(:result)   { subject.parse(unparsed) }

      it 'Returns an array of parsed practice hashes' do
        expect(result.size).to eq(3)
      end

      context 'Null practice data' do
        it 'Should return empty array' do
          expect(subject.parse(nil)).to eq([])
        end
      end
    end

  end
end
