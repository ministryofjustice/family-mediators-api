module Admin
  module Processing
    describe Headings do
      it "Replaces spaces with underscores" do
        expect(described_class.call(["foo bar"])).to eq [:foo_bar]
      end

      it "Downcases" do
        expect(described_class.call(%w[FooBar])).to eq [:foobar]
      end

      it "Replaces slashes with underscores" do
        expect(described_class.call(["foo/bar"])).to eq [:foo_bar]
      end

      it "Replaces multiple non alpha chars with ONE underscore" do
        expect(described_class.call(["foo@@@£££££bar"])).to eq [:foo_bar]
        expect(described_class.call(["foo     bar"])).to eq [:foo_bar]
      end

      it "Handles an array correctly" do
        expect(described_class.call(%w[foo bar])).to eq %i[foo bar]
      end
    end
  end
end
