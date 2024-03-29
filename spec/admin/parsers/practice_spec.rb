module Admin
  module Parsers
    describe Practice do
      context "when checking if a string is a URL" do
        %w[http://foo.com https://foo.com foo.com http://www.bar.co.uk foo.com/a/path/ http://foo.com/a/path/].each do |url|
          it "matches URL of the form: #{url}" do
            expect(url).to match(Practice::URL_REGEX)
          end
        end

        it "does not match an email-like string" do
          expect(Practice::URL_REGEX).not_to match("andy@foo.com")
        end
      end

      context "when checking if a string is a telephone number" do
        ["07974877182", "0201 3082097", "0300 4000636", "123456789", "07977 789786"].each do |tel|
          it "matches telephone number of the form: #{tel}" do
            expect(tel).to match(Practice::TEL_REGEX)
          end
        end
      end

      context "when checking if a string is a postcode" do
        ["BN20GB", "SW17 8LA", "WC1 R4HA"].each do |postcode|
          it "matches postcode of the form: #{postcode}" do
            expect(postcode).to match(Practice::POSTCODE_REGEX)
          end
        end
      end

      context "when null practice data is given" do
        it "returns empty array" do
          expect(described_class.parse(nil)).to eq([])
        end
      end

      context "when a single unparsed practice is given" do
        subject(:practice_upload) { described_class.parse(unparsed_practice)[0] }

        context "when postcode is present" do
          let(:unparsed_practice) { create(:unparsed_practice) }

          it { is_expected.to include(address: create(:parsed_practice)[:address]) }
        end

        context "when the postcode is missing" do
          let(:unparsed_practice) { create(:unparsed_practice, :missing_postcode) }

          it { is_expected.not_to include(:address) }
        end

        context "when a phone number-like string is present" do
          let(:unparsed_practice) { create(:unparsed_practice_all_parts) }

          it { is_expected.to include(tel: create(:parsed_practice_all_parts)[:tel]) }
        end

        context "when phone number-like string is not present" do
          let(:unparsed_practice) { create(:unparsed_practice) }

          it { is_expected.not_to include(:tel) }
        end

        context "when email-like string is present" do
          let(:unparsed_practice) { create(:unparsed_practice_all_parts) }

          it { is_expected.to include(email: create(:parsed_practice_all_parts)[:email]) }
        end

        context "when email-like string is not present" do
          let(:unparsed_practice) { create(:unparsed_practice) }

          it { is_expected.not_to include(:email) }
        end

        context "when url-like string is present" do
          let(:unparsed_practice) { create(:unparsed_practice_all_parts) }

          it { is_expected.to include(url: create(:parsed_practice_all_parts)[:url]) }
        end

        context "when url-like string is not present" do
          let(:unparsed_practice) { create(:unparsed_practice) }

          it { is_expected.not_to include(:url) }
        end

        context "when all parts present" do
          let(:unparsed_practice) { create(:unparsed_practice_all_parts) }
          let(:parsed_practice) { create(:parsed_practice_all_parts) }

          it { is_expected.to include(address: parsed_practice[:address]) }
          it { is_expected.to include(tel: parsed_practice[:tel]) }
          it { is_expected.to include(email: parsed_practice[:email]) }
          it { is_expected.to include(url: parsed_practice[:url]) }
        end

        context "when parts are in different order" do
          let(:unparsed_practice) { create(:shuffled_unparsed_practice) }
          let(:parsed_practice) { create(:parsed_practice_all_parts) }

          it { is_expected.to include(address: parsed_practice[:address]) }
          it { is_expected.to include(tel: parsed_practice[:tel]) }
          it { is_expected.to include(email: parsed_practice[:email]) }
          it { is_expected.to include(url: parsed_practice[:url]) }
        end

        context "when parts have whitespace" do
          let(:unparsed_practice) { create(:whitespaced_unparsed_practice) }
          let(:parsed_practice) { create(:parsed_practice_all_parts) }

          it "removes excess whitespace for address" do
            expect(practice_upload).to include(address: parsed_practice[:address])
          end

          it "removes excess whitespace for tel" do
            expect(practice_upload).to include(tel: parsed_practice[:tel])
          end

          it "removes excess whitespace for email" do
            expect(practice_upload).to include(email: parsed_practice[:email])
          end

          it "removes excess whitespace for url" do
            expect(practice_upload).to include(url: parsed_practice[:url])
          end
        end
      end

      context "when multiple practices are given" do
        subject(:practices) { described_class.parse(unparsed_practices) }
        let(:unparsed_practices) do
          "#{create(:unparsed_practice)}
          #{create(:unparsed_practice)}
          #{create(:unparsed_practice)}"
        end

        it "when an array of parsed practice hashes is returned" do
          expect(practices.size).to eq(3)
        end
      end
    end
  end
end
