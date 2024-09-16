module Admin
  module Processing
    describe RecordRemover do
      subject(:remover) { described_class.new(records) }

      describe "when there are blank records" do
        let(:records) { [record_blanks, record_normal] }
        let(:record_blanks) { { first_name: "", last_name: "", urn: nil } }
        let(:record_normal) { { first_name: "John", last_name: "Smith", urn: "1234A" } }

        it "Removes blank fields" do
          expect(remover.call).to eq([record_normal])
        end
      end

      describe "when there are student records" do
        let(:records) { [record_certified, record_student] }
        let(:record_certified) { { first_name: "Jane", last_name: "Jones", urn: "1234A" } }
        let(:record_student) { { first_name: "John", last_name: "Smith", urn: "1234S" } }

        it "Removes students" do
          expect(remover.call).to eq([record_certified])
        end
      end
    end
  end
end
