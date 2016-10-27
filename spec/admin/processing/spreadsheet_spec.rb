require 'spec_helper'

module Admin
  module Processing
    describe Spreadsheet do

      let(:filepath) do
        File.expand_path('../../../support/fixtures/spreadsheet.xlsx', __FILE__)
      end

      subject do
        Admin::Processing::Spreadsheet.new(filepath)
      end

      before do
        allow(Admin::Processing::Headings).to receive(:process) { [] }
        allow(API::Models::Mediator).to receive(:create)
      end

      it 'should process headings' do
        expect(Admin::Processing::Headings).to receive(:process)
        subject.process
      end

      it 'should insert into DB' do
        expect(API::Models::Mediator).to receive(:create).at_least(:once)
        subject.process
      end
    end
  end
end
