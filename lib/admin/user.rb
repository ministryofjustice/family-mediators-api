require 'bcrypt'

module Admin
  class User
    include BCrypt
    attr_reader :name

    def self.authenticate(params = {})
      return nil if params[:username].blank? || params[:password].blank?

      username = params[:username].downcase
      return nil if username != ENV['USERNAME']

      password_hash = Password.new(ENV['PASSWORD_HASH'])
      User.new(username) if password_hash == params[:password]
    end

    def initialize(username)
      @name = username.capitalize
    end
  end
end
