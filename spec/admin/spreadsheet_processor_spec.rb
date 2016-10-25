require 'spec_helper'

describe Admin::SpreadsheetProcessor do

  let(:filepath) do
    File.expand_path('../../support/fixtures/spreadsheet.xlsx', __FILE__)
  end

  subject do
    Admin::SpreadsheetProcessor.new(filepath)
  end

  before do
    allow(Admin::HeadingsProcessor).to receive(:process) { [] }
    allow(API::Models::Mediator).to receive(:create)
  end

  it 'should process headings' do
    expect(Admin::HeadingsProcessor).to receive(:process)
    subject.process
  end

  it 'should insert into DB' do
    expect(API::Models::Mediator).to receive(:create).at_least(:once)
    subject.process
  end
end
