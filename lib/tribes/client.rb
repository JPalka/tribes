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

      @player_list = nil
      @village_list = nil
      @world = world_id
    end

    def player_list
      @player_list ||= download_player_list
    end

    def village_list
      @village_list ||= download_village_list
    end

    private

    def download_player_list
      connection = Faraday.new(url: world_list[world]) do |faraday|
        faraday.use FaradayMiddleware::FollowRedirects
      end
      response = connection.get('/map/player.txt')
      parse_player_list(response.body)
    end

    def download_village_list
      connection = Faraday.new(url: world_list[world]) do |faraday|
        faraday.use FaradayMiddleware::FollowRedirects
      end
      response = connection.get('/map/village.txt')
      parse_village_list(response.body)
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

    def parse_player_list(content)
      content.split(' ').map do |line|
        id, name, tribe_id, village_count, points, rank = line.split(',')
        { name: name, id: id.to_i, tribe_id: tribe_id.to_i, village_count: village_count.to_i,
          points: points.to_i, rank: rank.to_i }
      end
    end

    def parse_village_list(content)
      content.split(' ').map do |line|
        id, name, x, y, player_id, points, rank = line.split(',')
        { id: id.to_i, name: name, x: x.to_i, y: y.to_i,
          player_id: player_id.to_i, points: points.to_i, rank: rank.to_i }
      end
    end
  end
end
