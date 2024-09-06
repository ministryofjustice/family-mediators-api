module Admin
  module Processing
    describe ConfidentialFieldRemover do
      subject(:sanitise) { described_class }

      let(:records) { [record_a, record_b] }
      let(:record_a) { { foo: 1, top_secret: 42, sensitive: 43 } }
      let(:record_b) { { foo: 2, top_secret: 43, sensitive: 44 } }
      let(:confidentialised) { [{ foo: 1 }, { foo: 2 }] }
      let(:blacklist) { %i[top_secret sensitive] }

      it "Removes confidential fields" do
        expect(sanitise.call(records, blacklist)).to eq(confidentialised)
      end
    end
  end
end
