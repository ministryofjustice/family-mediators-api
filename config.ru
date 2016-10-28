$LOAD_PATH.unshift File.dirname(__FILE__)
$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")

require 'lib/env'
require 'lib/mediators'

map '/api' do
  map '/' do
    run API::App
  end
  map '/documentation' do
    class Doc < Sinatra::Base
      get '/' do
        send_file 'documentation/output.html'
      end
    end
    run Doc
  end

end

map '/admin' do
  run Admin::App
end
