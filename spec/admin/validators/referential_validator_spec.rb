module Admin
  module Validators
    describe ReferentialValidator do
      describe "registration numbers" do
        context "when unique" do
          let(:result) do
            ReferentialValidator.new(create(:mediator_list)).validate
          end

          it "is valid" do
            expect(result.success?).to eq(true)
          end

          it "has no error messages" do
            expect(result.messages.count).to eq(0)
          end
        end

        context "when not unique" do
          let(:result) do
            data = [
              create(:mediator_hash, urn: "4567A", ppc_urn: "1000T"),
              create(:mediator_hash, urn: "4567A", ppc_urn: "1000T"),
              create(:mediator_hash, urn: "1000T", ppc_urn: "4567A"),
            ]
            ReferentialValidator.new(data).validate
          end

          it "is invalid" do
            expect(result.success?).to eq(false)
          end

          it "has 1 error message" do
            expect(result.messages.count).to eq(1)
          end

          context "error message" do
            let(:error_message) { result.messages[0] }

            it "has heading 'Duplicate registration numbers'" do
              expect(error_message.heading).to eq("Duplicate URN")
            end

            it "has values '[4567A']" do
              expect(error_message.values).to eq(%w[4567A])
            end
          end

          context "and when ppc_urn not recognised" do
            let(:result) do
              invalid_ppc_urn = "4756T"
              data_with_unrecognised_ppc_urn = [
                create(:mediator_hash, urn: "4567A", ppc_urn: "1000T"),
                create(:mediator_hash, urn: "4567A", ppc_urn: invalid_ppc_urn),
                create(:mediator_hash, urn: "1000T", ppc_urn: "4567A"),
              ]
              ReferentialValidator.new(data_with_unrecognised_ppc_urn).validate
            end

            it "is invalid" do
              expect(result.success?).to eq(false)
            end

            it "has 2 error message" do
              expect(result.messages.count).to eq(2)
            end

            context "error messages" do
              let(:error_messages) { result.messages }

              it "has heading 'Duplicate registration numbers'"  do
                expect(error_messages[0].heading).to eq("PPC URN not recognised")
                expect(error_messages[1].heading).to eq("Duplicate URN")
              end

              it "has values '[4567A']" do
                expect(error_messages[0].values).to eq(%w[4756T])
                expect(error_messages[1].values).to eq(%w[4567A])
              end
            end
          end
        end
      end

      describe "ppc_urn" do
        context "when exists as registration number" do
          let(:result) do
            data = create(:mediator_list)
            ReferentialValidator.new(data).validate
          end

          it "is valid" do
            expect(result.success?).to eq(true)
          end

          it "has no error messages" do
            expect(result.messages.count).to eq(0)
          end
        end

        # In the past, the PPC URN was sometimes set to 'not known' - this is
        # no longer allowed.
        context "when is set to 'not known'" do
          let(:result) do
            data = [
              create(:mediator_hash, urn: "1234A", ppc_urn: "1000T"),
              create(:mediator_hash, urn: "4567A", ppc_urn: "not known"),
              create(:mediator_hash, urn: "1000T", ppc_urn: "4567A"),
            ]
            ReferentialValidator.new(data).validate
          end

          it "is invalid" do
            expect(result.success?).to eq(false)
          end
        end

        context "when does not exist as registration number" do
          let(:result) do
            invalid_ppc_urn = "4756T"
            data = [
              create(:mediator_hash, urn: "1234A", ppc_urn: "1000T"),
              create(:mediator_hash, urn: "4567A", ppc_urn: invalid_ppc_urn),
              create(:mediator_hash, urn: "1000T", ppc_urn: "4567A"),
            ]
            ReferentialValidator.new(data).validate
          end

          it "is invalid" do
            expect(result.success?).to eq(false)
          end

          it "has 1 error message" do
            expect(result.messages.count).to eq(1)
          end

          context "error message" do
            let(:error_message) { result.messages[0] }

            it "has heading 'PPC_ID does not exist'" do
              expect(error_message.heading).to eq("PPC URN not recognised")
            end

            it "has values ['4756T']" do
              expect(error_message.values).to eq(%w[4756T])
            end
          end
        end
      end
    end
  end
end
