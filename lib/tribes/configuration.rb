module Tribes
  class Client
    class Configuration
      attr_accessor :login, :password, :remote_host

      def initialize
        @remote_host = 'https://www.tribalwars.net'
        @login = 'login'
        @password = 'password'
      end
    end
  end
end
