module Admin
  module Validators
    describe ReferentialValidator do

      let(:valid_input_1) do
        {
            'registration_no' => '1234A',
            'md_offers_dcc' => 'Y',
            'md_first_name' => 'John',
            'md_last_name' => 'Smith',
            'md_mediation_legal_aid' => 'Y',
            'md_ppc_id' => '3452A'
        }
      end

      let(:valid_input_2) do
        {
            'registration_no' => '4567A',
            'md_offers_dcc' => 'Y',
            'md_first_name' => 'John',
            'md_last_name' => 'Smith',
            'md_mediation_legal_aid' => 'Y',
            'md_ppc_id' => '3452A'
        }
      end

      let(:valid_input_3) do
        {
            'registration_no' => '3452A',
            'md_offers_dcc' => 'Y',
            'md_first_name' => 'John',
            'md_last_name' => 'Smith',
            'md_mediation_legal_aid' => 'Y',
            'md_ppc_id' => '4567A'
        }
      end

      describe 'registration numbers' do
        context 'when unique' do
          let(:result) do
            data = [valid_input_1, valid_input_2, valid_input_3]
            ReferentialValidator.new(data).validate
          end

          it 'is valid' do
            expect(result.success?).to eq(true)
          end

          it 'has no error messages' do
            expect(result.messages.count).to eq(0)
          end
        end

        context 'when not unique' do
          let(:result) do
            data = [
                valid_input_1.merge('registration_no' => '4567A'),
                valid_input_2.merge('registration_no' => '4567A'),
                valid_input_3
            ]
            ReferentialValidator.new(data).validate
          end

          it 'is invalid' do
            expect(result.success?).to eq(false)
          end

          it 'has 1 error message' do
            expect(result.messages.count).to eq(1)
          end

          context 'error message' do
            let(:error_message) { result.messages[0] }

            it "has heading 'Duplicate registration numbers'"  do
              expect(error_message.heading).to eq('Duplicate registration numbers')
            end

            it "has values '[4567A']"  do
              expect(error_message.values).to eq(['4567A'])
            end
          end

          context 'and when md_ppc_id not recognised' do
            let(:result) do
              invalid_ppc_id = '4756T'
              data_with_unrecognised_md_ppc_id = [
                  valid_input_1.merge('registration_no' => '4567A'),
                  valid_input_2.merge('registration_no' => '4567A').merge('md_ppc_id' => invalid_ppc_id),
                  valid_input_3
              ]
              ReferentialValidator.new(data_with_unrecognised_md_ppc_id).validate
            end

            it 'is invalid' do
              expect(result.success?).to eq(false)
            end

            it 'has 2 error message' do
              expect(result.messages.count).to eq(2)
            end

            context 'error messages' do
              let(:error_messages) { result.messages }

              it "has heading 'Duplicate registration numbers'"  do
                expect(error_messages[0].heading).to eq('MD_PPC_ID not recognised')
                expect(error_messages[1].heading).to eq('Duplicate registration numbers')
              end

              it "has values '[4567A']"  do
                expect(error_messages[0].values).to eq(['4756T'])
                expect(error_messages[1].values).to eq(['4567A'])
              end
            end
          end
        end
      end

      describe 'md_ppc_id' do
        context 'when exists as registration number' do
          let(:result) do
            data = [valid_input_1, valid_input_2, valid_input_3]
            ReferentialValidator.new(data).validate
          end

          it 'is valid' do
            expect(result.success?).to eq(true)
          end

          it 'has no error messages' do
            expect(result.messages.count).to eq(0)
          end
        end

        context "when is set to 'not known'" do
          let(:result) do
            data = [
                valid_input_1,
                valid_input_2.merge('md_ppc_id' => 'not known'),
                valid_input_3
            ]
            ReferentialValidator.new(data).validate
          end

          it 'is valid' do
            expect(result.success?).to eq(true)
          end

        end

        context 'when does not exist as registration number' do
          let(:result) do
            invalid_ppc_id = '4756T'
            data = [
                valid_input_1,
                valid_input_2.merge('md_ppc_id' => invalid_ppc_id),
                valid_input_3
            ]
            ReferentialValidator.new(data).validate
          end

          it 'is invalid' do
            expect(result.success?).to eq(false)
          end

          it 'has 1 error message' do
            expect(result.messages.count).to eq(1)
          end

          context 'error message' do
            let(:error_message) { result.messages[0] }

            it "has heading 'PPC_ID does not exist'"  do
              expect(error_message.heading).to eq('MD_PPC_ID not recognised')
            end

            it "has values ['4756T']"  do
              expect(error_message.values).to eq(['4756T'])
            end
          end
        end
      end
    end
  end
end