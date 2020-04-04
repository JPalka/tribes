module Tribes
  class Client
    class Configuration
      attr_accessor :login, :password
      attr_reader :remote_host, :current_world

      def initialize
        @remote_host = 'https://www.tribalwars.net'
        @login = 'login'
        @password = 'password'
        @world_list = nil
      end

      def remote_host=(value)
        assert_host_valid(value)
        @remote_host = value
      end

      def current_world=(value)
        assert_world_valid(value)
        @current_world = value
      end

      def world_list
        @world_list ||= download_world_list
      end

      private

      def assert_host_valid(value)
        URI.parse(value)
      rescue URI::InvalidURIError
        raise ArgumentError, 'Argument is not a valid URL'
      end

      def assert_world_valid(value)
        raise ArgumentError, "World not found: #{value}" unless world_list.key?(value)
      end

      def download_world_list
        connection = Faraday.new(url: remote_host) do |faraday|
          faraday.use FaradayMiddleware::FollowRedirects
        end
        response = connection.get('/backend/get_servers.php')
        world_links = response.body.scan(%r{https:\/\/.[^"]+})
        world_links.each_with_object({}) do |link, hash|
          hash[link.scan(%r{(?<=\/{2}).[^\.]+})[0]] = link
        end
      end
    end
  end
end
