# frozen_string_literal: true

module Tribes
  class Client
    attr_reader :base_link, :world

    def initialize(base_url = 'https://tribalwars.net')
      begin
        URI.parse(base_url)
      rescue URI::InvalidURIError
        raise ArgumentError, 'Argument is not a valid URL'
      end

      @base_link = base_url
    end

    def world_list
      @world_list ||= download_world_list
    end

    def world=(world_id)
      raise ArgumentError, "World not found: #{world_id}" unless world_list.key?(world_id)

      @world = world_id
    end

    private

    def download_world_list
      connection = Faraday.new(url: base_link) do |faraday|
        faraday.use FaradayMiddleware::FollowRedirects
      end
      response = connection.get(base_link + '/backend/get_servers.php')
      world_links = response.body.scan(%r{https:\/\/.[^"]+})
      world_links.each_with_object({}) do |link, hash|
        hash[link.scan(%r{(?<=\/{2}).[^\.]+})[0]] = link
      end
    end
  end
end
