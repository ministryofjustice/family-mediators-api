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

  end
end