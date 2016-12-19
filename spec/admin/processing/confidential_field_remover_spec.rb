module Admin
  module Processing
    describe ConfidentialFieldRemover do

      let(:records) { [ record1, record2 ] }
      let(:record1) { { foo: 1, top_secret: 42, sensitive: 43 } }
      let(:record2) { { foo: 2, top_secret: 43, sensitive: 44 } }
      let(:confidentialised) { [ {foo: 1}, {foo: 2} ] }
      let(:blacklist) { [:top_secret, :sensitive] }

      it 'Removes confidential fields' do
        expect(subject.call(records, blacklist)).to eq(confidentialised)
      end
    end
  end
end
