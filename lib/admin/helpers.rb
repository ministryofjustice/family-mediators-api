module Admin
  module Helpers
    def build_messages(messages)
      messages.values.map.with_index(1) do |errors, index|
        # Following line copes with injected PracticeValidator errors in `rule(:practices)`
        values = errors.is_a?(Hash) ? errors.values : errors
        "Practice #{index}: #{values.join(' AND ')}"
      end
    end

    def authenticate!
      unless session[:user]
        session[:original_request] = request.path_info
        redirect url("/login")
      end
    end

    def redirect_to_original_request
      original_request = session[:original_request] || "/actions"
      session[:original_request] = nil
      redirect url(original_request)
    end
  end
end
