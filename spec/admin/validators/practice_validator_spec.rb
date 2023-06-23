module Admin
  module Validators
    describe PracticeValidator do
      subject(:result) do
        PracticeValidator.new.call(practice_hash)
      end

      describe "practices" do
        describe "telephone number" do
          [
            "07345 123 345",
            "07345123345",
            "+44 7345 123 345",
            "+447345123345",
            "020 8123 5678 ext234",
          ].each do |phone_number|
            context "when #{phone_number}" do
              let(:practice_hash) { create(:parsed_practice, tel: phone_number) }
              it { should be_valid }
            end
          end

          context "when too short" do
            let(:practice_hash) { create(:parsed_practice, tel: "01234") }
            it { should_not be_valid }
          end

          context "when alpha" do
            let(:practice_hash) { create(:parsed_practice, tel: "abcdef") }
            it { should_not be_valid }
          end
        end

        describe "url" do
          %w[http://www.gov.uk
             http://www.gov.uk/mediators
             http://www.gov.uk/mediators/
             http://www.gov.uk/mediators/?type
             http://www.gov.uk/mediators/?type=family
             https://www.gov.uk/mediators/?type=family].each do |url|
            context "when #{url}" do
              let(:practice_hash) { create(:parsed_practice, url:) }
              it { should be_valid }
            end
          end

          context "when scheme is missing" do
            let(:practice_hash) { create(:parsed_practice, url: "www.gov.uk") }
            it { should_not be_valid }
          end

          context "when scheme is file" do
            let(:practice_hash) { create(:parsed_practice, url: "file://www.gov.uk") }
            it { should_not be_valid }
          end
        end

        describe "email" do
          context "when string that is not email address" do
            let(:practice_hash) { create(:parsed_practice_all_parts, email: "valid@@email.com") }
            it { should_not be_valid }
          end

          context "when string is email address" do
            let(:practice_hash) { create(:parsed_practice_all_parts) }
            it { should be_valid }
          end
        end

        describe "address" do
          context "when nil" do
            let(:practice_hash) { create(:parsed_practice, address: nil) }
            it { should_not be_valid }
          end

          context "when is filled with a string" do
            let(:practice_hash) { create(:parsed_practice) }
            it { should be_valid }
          end

          context "when is empty string" do
            let(:practice_hash) { create(:parsed_practice, address: "") }
            it { should be_valid }
          end
        end
      end

      context "when is more than one address" do
        let(:address) { "15 Smith Street, London WC1R 4RL" }
        let(:practice_hash) { create(:parsed_practice, address: [address, address]) }
        it { should_not be_valid }
      end
    end
  end
end
