module Console
  class << self
    def error(message)
      puts "[ \033[0;31mERROR\033[0m ] #{message}"
    end
  end
end
