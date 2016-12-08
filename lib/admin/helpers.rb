module Admin
  module Helpers
    def build_messages(messages)
      html = []
      messages.each do |index, errors|
        title = "Practice #{index + 1}: "
        html << "#{title} #{errors.values.join(' AND ')}"
      end
      html
    end

    def authenticate!
      unless session[:user]
        session[:original_request] = request.path_info
        redirect url('/login')
      end
    end

    def redirect_to_original_request
      original_request = session[:original_request] || '/actions'
      session[:original_request] = nil
      redirect url(original_request)
    end
  end
end