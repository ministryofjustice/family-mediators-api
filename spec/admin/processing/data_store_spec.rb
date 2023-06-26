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
        allow(API::Models::Mediator).to receive(:create)
      end

      it "inserts into DB" do
        expect(API::Models::Mediator).to receive(:create).once
        described_class.save!(data)
      end
    end
  end
end
