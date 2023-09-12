module Admin
  module Validators
    describe MediatorValidator do
      subject(:result) do
        described_class.new.call(data)
      end

      describe("practices") do
        context "when 1 practices" do
          let(:data) do
            create(:mediator_hash, :include_practice)
          end

          it { is_expected.to be_valid }

          it "includes practices" do
            expect(data).to include(:practices)
          end
        end
      end

      describe "urn" do
        it_behaves_like "a URN", "urn"
        it_behaves_like "a required field", "urn", "1001T"
      end

      describe "ppc_urn" do
        it_behaves_like "a URN", "ppc_urn"

        context "when blank" do
          let(:data) { create(:mediator_hash, ppc_urn: "") }

          it { is_expected.to be_valid }
        end
      end

      %w[dcc legal_aid_qualified legal_aid_franchise].each do |field_name|
        describe field_name do
          it_behaves_like "a required boolean", field_name
        end
      end

      %w[title first_name last_name].each do |field_name|
        describe field_name do
          it_behaves_like "a required field", field_name
          it_behaves_like "a string", field_name
        end
      end

      %w[fmca_date training_date].each do |field_name|
        describe field_name do
          it_behaves_like "an optional date", field_name
        end
      end

      describe "fmca_date or training_date" do
        context "when both blank" do
          let(:data) { create(:mediator_hash, fmca_date: nil, training_date: nil) }

          it { is_expected.not_to be_valid }
        end
      end

      describe("missing properties") do
        subject(:result) do
          described_class.new.call(missing_data)
        end

        keys = FactoryBot.create(:mediator_hash).keys - [:ppc_urn]

        keys.each do |val|
          context "when #{val} missing" do
            let(:missing_data) { create(:mediator_hash).tap { |key| key.delete(val) } }

            it { is_expected.not_to be_valid }
          end
        end
      end
    end
  end
end
