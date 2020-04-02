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

    def world_list; end
  end
end
