# frozen_string_literal: true

module Tribes
  class Client
    attr_reader :base_link

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

    private

    def download_world_list
      world_links = Faraday.get(base_link + '/backend/get_servers.php')
                           .body
                           .scan(%r{https:\/\/.[^"]+})
      world_links.each_with_object({}) do |link, hash|
        hash[link.scan(%r{(?<=\/{2}).[^\.]+})[0]] = link
      end
    end
  end
end
