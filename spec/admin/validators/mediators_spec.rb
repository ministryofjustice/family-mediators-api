module Admin
  module Validators
    describe Mediators do
      let(:valid_registration_no) { { 'registration_no' => '0123A' } }
      let(:invalid_registration_no) { { 'registration_no' => 'Y776G' } }
      let(:nil_registration_no) { { 'registration_no' => nil } }
      let(:blank_registration_no) { { 'registration_no' => ' ' } }

      let(:non_unique_registration_nos) do
        [
          { 'registration_no' => '0123T' },
          { 'registration_no' => '0999T' },
          { 'registration_no' => '0999T' }
        ]
      end

      let(:result) { subject.validate }

      context 'Registration number' do
        context 'Missing' do
          context 'Nil' do
            subject { Mediators.new([nil_registration_no]) }

            it 'Returns false' do
              expect(result).to eq false
            end

            it 'Stores an error' do
              result
              expect(subject.errors[0][:message]).to eq 'is required'
              expect(subject.errors[0][:field]).to eq :registration_no
              expect(subject.errors[0][:level]).to eq :fatal
              expect(subject.errors[0][:row_no]).to eq 1
            end
          end

          context 'Blank' do
            subject { Mediators.new([blank_registration_no]) }

            it 'Returns false' do
              expect(result).to eq false
            end

            it 'Stores an error' do
              result
              expect(subject.errors[0][:message]).to eq 'is required'
              expect(subject.errors[0][:field]).to eq :registration_no
              expect(subject.errors[0][:level]).to eq :fatal
              expect(subject.errors[0][:row_no]).to eq 1
            end
          end

        end

        context 'Invalid' do
          subject { Mediators.new([invalid_registration_no]) }

          it 'Returns false' do
            expect(result).to eq false
          end

          it 'Stores an error' do
            result
            expect(subject.errors[0][:message]).to eq 'must be of the format nnnnT, nnnnA, or nnnnP'
            expect(subject.errors[0][:field]).to eq :registration_no
            expect(subject.errors[0][:level]).to eq :fatal
            expect(subject.errors[0][:row_no]).to eq 1
          end
        end

        context 'Valid' do
          subject { Mediators.new([valid_registration_no]) }

          it 'Returns true' do
            expect(result).to eq true
          end

          it 'Stores no errors' do
            result
            expect(subject.errors.any?).to eq false
          end
        end

        context 'Not unique' do
          subject { Mediators.new(non_unique_registration_nos) }

          it 'Returns false' do
            expect(result).to eq false
          end

          it 'Stores an error' do
            result
            expect(subject.errors[0][:message]).to eq 'is not unique'
            expect(subject.errors[0][:field]).to eq :registration_no
            expect(subject.errors[0][:level]).to eq :fatal
            expect(subject.errors[0][:row_no]).to eq 2
          end
        end

      end
    end
  end
end