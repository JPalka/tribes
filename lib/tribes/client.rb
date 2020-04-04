# frozen_string_literal: true

module Tribes
  class Client
    attr_reader :base_link, :world
    attr_accessor :configuration

    include Tribes::Parser

    def initialize(base_url = 'https://tribalwars.net')
      begin
        URI.parse(base_url)
      rescue URI::InvalidURIError
        raise ArgumentError, 'Argument is not a valid URL'
      end

      @base_link = base_url
    end

    def configure
      @configuration ||= Configuration.new
      yield(configuration)
    end

    def world_list
      @world_list ||= download_world_list
    end

    def world=(world_id)
      raise ArgumentError, "World not found: #{world_id}" unless world_list.key?(world_id)

      @player_list = nil
      @village_list = nil
      @tribe_list = nil
      @world_config = nil
      @building_info = nil
      @unit_info = nil
      @connection = Faraday.new(url: world_list[world_id]) do |faraday|
        faraday.use FaradayMiddleware::FollowRedirects
      end
      @world = world_id
    end

    def player_list
      @player_list ||= download_player_list
    end

    def village_list
      @village_list ||= download_village_list
    end

    def tribe_list
      @tribe_list ||= download_tribe_list
    end

    def world_config
      @world_config ||= download_world_config
    end

    def building_info
      @building_info ||= download_building_info
    end

    def unit_info
      @unit_info ||= download_unit_info
    end

    private

    def download_player_list
      response = @connection.get('/map/player.txt')
      parse_player_list(response.body)
    end

    def download_village_list
      response = @connection.get('/map/village.txt')
      parse_village_list(response.body)
    end

    def download_tribe_list
      response = @connection.get('/map/ally.txt')
      parse_tribe_list(response.body)
    end

    def download_world_config
      response = @connection.get('/interface.php?func=get_config')
      parse_config(response.body)
    end

    def download_building_info
      response = @connection.get('/interface.php?func=get_building_info')
      parse_config(response.body)
    end

    def download_unit_info
      response = @connection.get('/interface.php?func=get_unit_info')
      parse_config(response.body)
    end

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
