module Admin
  module Parsers
    describe Workbook do
      subject { described_class.new(rubyxl_workbook) }

      let(:headings) { ["First Name", "Last Name"] }

      let(:rubyxl_workbook) do
        Support::Factories::Spreadsheet.build(headings, data, blacklist)
      end

      context "with normal data" do
        let(:data) { [%w[John Smith], %w[Donna Jones]] }
        let(:blacklist) { ["Bish bosh", "bash"] }

        let(:expected_data) do
          [
            { first_name: "John", last_name: "Smith" },
            { first_name: "Donna", last_name: "Jones" },
          ]
        end

        let(:expected_blacklist) { %i[bish_bosh bash] }

        it "Returns 2 arrays" do
          expect(subject.call.size).to eq(2)
          expect(subject.call.first).to be_an(Array)
          expect(subject.call.last).to be_an(Array)
        end

        it "First array is data" do
          expect(subject.call.first).to eq(expected_data)
        end

        it "Second array is array of blacklisted cols" do
          expect(subject.call.last).to eq(expected_blacklist)
        end
      end

      context "with null values for blank cells" do
        let(:data) { [%w[John Smith], [nil, "Baker"], %w[Donna Jones]] }
        let(:blacklist) { [] }

        let(:expected_data) do
          [
            { first_name: "John", last_name: "Smith" },
            { first_name: nil, last_name: "Baker" },
            { first_name: "Donna", last_name: "Jones" },
          ]
        end

        it "Transforms data" do
          expect(subject.call.first).to eq(expected_data)
        end
      end

      context "when there are empty rows" do
        let(:data) { [%w[Bob Bobbins], [nil, ""]] }
        let(:blacklist) { [] }

        let(:expected_data) do
          [{ first_name: "Bob", last_name: "Bobbins" }]
        end

        it "Ignores empty rows" do
          expect(subject.call.first).to eq(expected_data)
        end
      end

      context "when there is an empty workbook" do
        let(:headings) { [] }
        let(:data) { [] }
        let(:blacklist) { [] }

        it "Returns empty data array" do
          expect(subject.call.first).to eq([])
        end

        it "Returns empty blacklist array" do
          expect(subject.call.last).to eq([])
        end
      end
    end
  end
end
