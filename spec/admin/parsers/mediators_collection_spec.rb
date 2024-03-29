module Admin
  module Parsers
    describe MediatorsCollection do
      context "when empty array" do
        it "returns empty array" do
          expect(described_class.new([]).parsed_data).to eq([])
        end
      end

      context "when not array of hashes" do
        it "raises ArgumentError" do
          expect { described_class.new([1]) }.to raise_error(ArgumentError)
        end
      end

      context "when data does not contain practice data" do
        it "returns the same hash" do
          mediator_hash = create(:mediator_hash)
          parsed_mediator = described_class.new([mediator_hash]).parsed_data
          expect(parsed_mediator).to eq([mediator_hash])
        end
      end

      context "when practice value data is null" do
        it "returns empty same hash with no practice key" do
          mediator_hash = create(:mediator_hash, practices: nil)
          parsed_mediator = described_class.new([mediator_hash]).parsed_data
          expected = mediator_hash.except!(:practices)
          expect(parsed_mediator).to eq([expected])
        end
      end

      context "when data contains practice data" do
        it "contains parsed practice hash" do
          mediator_hash = create(:mediator_hash, :include_unparsed_practice)
          parsed_mediator = described_class.new([mediator_hash]).parsed_data
          expected = mediator_hash.merge(practices: [{
            address: "15 Smith Street, London WC1R 4RL",
            email: "valid@email.com",
            tel: "01245 605040",
            url: "http://www.foobar.com/baz/",
          }])
          expect(parsed_mediator).to eq([expected])
        end
      end
    end
  end
end
