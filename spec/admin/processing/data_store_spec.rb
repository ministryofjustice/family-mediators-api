module Admin
  module Processing
    describe DataStore do
      let(:data) do
        [
          { "first_name" => "John", "last_name" => "Smith" },
          { "first_name" => "Donna", "last_name" => "Jones" },
        ]
      end

      before do
        allow(API::Models::Mediator).to receive(:create).and_return([])
      end

      it "inserts into DB" do
        expect(API::Models::Mediator).to receive(:create).once.and_return([])
        described_class.save(data)
      end

      it "returns the count of records written" do
        created = [double, double]
        allow(API::Models::Mediator).to receive(:create).and_return(created)
        expect(described_class.save(data)).to eq(2)
      end

      it "returns zero when no records are written" do
        allow(API::Models::Mediator).to receive(:create).and_return([])
        expect(described_class.save([])).to eq(0)
      end
    end
  end
end
