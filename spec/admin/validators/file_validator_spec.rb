module Admin
  module Validators
    describe FileValidator do
      context 'Invalidates empty file' do
        subject { FileValidator.new([], []) }

        it 'Deems invalid' do
          expect(subject.valid?).to eq(false)
        end

        it 'Error message' do
          subject.valid?
          expect(subject.errors).to eq(['The file contains no mediator data'])
        end
      end

      context 'Blacklist' do
        let(:mediators) { [ { foo: 42, bar: 43 } ] }

        context 'Found in data' do
          subject { FileValidator.new(mediators, %w{ foo }) }

          it 'Deems valid' do
            expect(subject.valid?).to eq(true)
          end
        end

        context 'Not found in data' do
          subject { FileValidator.new(mediators, %w{ bobbins }) }

          it 'Deems invalid' do
            expect(subject.valid?).to eq(false)
          end

          it 'Error message' do
            subject.valid?
            expect(subject.errors).to eq(['Blacklisted column not found in mediator data: bobbins'])
          end

        end
      end
    end
  end
end
