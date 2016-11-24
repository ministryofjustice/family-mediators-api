module Admin
  module Validators
    describe FileValidator do
      context 'Invalidates empty file' do
        subject { FileValidator.new([]) }

        it 'Deems invalid' do
          expect(subject.valid?).to eq(false)
        end

        it 'Error message' do
          subject.valid?
          expect(subject.errors).to eq(['The file contains no data'])
        end
      end
    end
  end
end