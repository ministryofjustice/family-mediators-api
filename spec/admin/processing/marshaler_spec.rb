module Admin
  module Processing
    describe Marshaler do
      subject(:marshal) { described_class }

      let(:array) do
        [42, "foo", { bish: 5, bosh: "hello" }]
      end

      let(:marshaled) do
        "eJyLNjHSUUrLz1fSqVZKyizOULIy1VFKygcxlDJSc3LylWpjAcEPCv4=\n"
      end

      it "Dumps" do
        expect(marshal.to_string(array)).to eq(marshaled)
      end

      it "Loads" do
        expect(marshal.to_array(marshaled)).to eq(array)
      end
    end
  end
end
