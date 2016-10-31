module Documentation
  class App < Sinatra::Base

    doc_path = File.expand_path('../../../documentation/output.html', __FILE__)

    get '/' do
      if File.exist? doc_path
        send_file doc_path
      end
      'Documentation has not been generated.'
    end
  end
end