module Tribes
  class Client
    class Configuration
      ATTRIBUTES = %i[login password remote_host].freeze
      attr_accessor :login, :password
      attr_reader :remote_host, :current_world, :base_connection

      def initialize
        @remote_host = 'https://www.tribalwars.net'
        @login = 'korenchkin'
        @password = 'rickenbacker1'
        @world_list = nil
        @base_connection = Faraday.new(url: remote_host) do |faraday|
          faraday.use FaradayMiddleware::FollowRedirects
        end
      end

      def remote_host=(value)
        assert_host_valid(value)
        @base_connection = Faraday.new(url: remote_host) do |faraday|
          faraday.use FaradayMiddleware::FollowRedirects
        end
        @remote_host = value
      end

      def world_list
        @world_list ||= download_world_list
      end

      def merge(options)
        unpermitted_options = options.keys.map(&:to_sym) - ATTRIBUTES
        if unpermitted_options.any?
          raise ArgumentError, "Invalid options: #{unpermitted_options.join(', ')}"
        end

        options.each { |option, value| send("#{option}=", value) }

        self
      end

      private

      def current_world=(value)
        assert_world_valid(value)
        @current_world = value
      end

      def assert_host_valid(value)
        URI.parse(value)
      rescue URI::InvalidURIError
        raise ArgumentError, 'Argument is not a valid URL'
      end

      def assert_world_valid(value)
        raise ArgumentError, "World not found: #{value}" unless world_list.key?(value)
      end

      def download_world_list
        response = base_connection.get('/backend/get_servers.php')
        world_links = response.body.scan(%r{https:\/\/.[^"]+})
        world_links.each_with_object({}) do |link, hash|
          hash[link.scan(%r{(?<=\/{2}).[^\.]+})[0]] = link
        end
      end
    end
  end
end
