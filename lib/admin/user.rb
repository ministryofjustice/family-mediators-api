require 'bcrypt'

module Admin
  refine Object do
    # An object is blank if it's false, empty, or a whitespace string.
    # For example, '', ' ', nil, [], and {} are all blank.
    def blank?
      respond_to?(:empty?) ? !!empty? : !self
    end
  end

  class User
    include BCrypt
    attr_reader :name

    def self.authenticate(params = {})
      return nil if params[:username].blank? || params[:password].blank?

      username = params[:username].downcase
      return nil if username != ENV['USERNAME']

      password_hash = Password.new(ENV['PASSWORD_HASH'])
      User.new(username) if password_hash == params[:password] # The password param gets hashed for us by the == method.
    end

    def initialize(username)
      @name = username.capitalize
    end
  end
end
