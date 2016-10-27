module Admin
  module Processing
    describe Headings do
      it 'Replaces spaces with underscores' do
        expect(Headings.process(['foo bar'])).to eq [ 'foo_bar' ]
      end

      it 'Downcases' do
        expect(Headings.process(['FooBar'])).to eq [ 'foobar' ]
      end

      it 'Replaces slashes with underscores' do
        expect(Headings.process(['foo/bar'])).to eq [ 'foo_bar' ]
      end

      it 'Replaces multiple non alpha chars with ONE underscore' do
        expect(Headings.process(['foo@@@£££££bar'])).to eq [ 'foo_bar' ]
        expect(Headings.process(['foo     bar'])).to eq [ 'foo_bar' ]
      end

      it 'Handles an array correctly' do
        expect(Headings.process(['foo','bar'])).to eq [ 'foo','bar' ]
      end
    end
  end
end
