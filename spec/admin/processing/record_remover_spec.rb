module Admin
  module Processing
    describe RecordRemover do
      subject(:remover) { described_class.new(records) }

      describe "when there are blank records" do
        let(:records) { [record_one, record_two] }
        let(:record_one) { {} }
        let(:record_two) { { foo: 2, top_secret: 43, sensitive: 44 } }

        it "Removes blank fields" do
          expect(remover.call).to eq([record_two])
        end
      end
    end
  end
end
