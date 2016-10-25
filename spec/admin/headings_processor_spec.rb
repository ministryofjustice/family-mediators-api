module Admin
  describe HeadingsProcessor do
    it 'Replaces spaces with underscores' do
      expect(HeadingsProcessor.process(['foo bar'])).to eq [ 'foo_bar' ]
    end

    it 'Downcases' do
      expect(HeadingsProcessor.process(['FooBar'])).to eq [ 'foobar' ]
    end

    it 'Replaces slashes with underscores' do
      expect(HeadingsProcessor.process(['foo/bar'])).to eq [ 'foo_bar' ]
    end

    it 'Replaces multiple non alpha chars with ONE underscore' do
      expect(HeadingsProcessor.process(['foo@@@£££££bar'])).to eq [ 'foo_bar' ]
      expect(HeadingsProcessor.process(['foo     bar'])).to eq [ 'foo_bar' ]
    end

    it 'Handles an array correctly' do
      expect(HeadingsProcessor.process(['foo','bar'])).to eq [ 'foo','bar' ]
    end
  end
end
