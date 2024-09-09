module Admin
  module Processing
    describe RecordRemover do
      subject(:remover) { described_class.new(records) }

      describe "when there are blank records" do
        let(:records) { [record_one, record_two] }
        let(:record_one) { { first_name: "", last_name: "", urn: nil } }
        let(:record_two) { { first_name: "John", last_name: "Smith", urn: "1234A" } }

        it "Removes blank fields" do
          expect(remover.call).to eq([record_two])
        end
      end
    end
  end
end
