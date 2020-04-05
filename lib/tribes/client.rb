# frozen_string_literal: true

module Tribes
  class Client
    include Tribes::Parser
    attr_reader :active_worlds

    def initialize(options = {})
      @configuration = Configuration.new
      @configuration.merge(options)
      @headers = Headers.new
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
      configuration
    end

    def world_list
      configuration.world_list
    end

    def world=(world_id)
      configuration.send(:current_world=, world_id)
      @connection = Faraday.new(url: world_list[world_id], headers: @headers.to_h) do |faraday|
        faraday.use FaradayMiddleware::FollowRedirects
        faraday.response :logger
      end
    end

    def login
      site = Tribes::Site::Login.new(connection: configuration.base_connection)
      response = site.download(login: configuration.login,
                               password: configuration.password,
                               headers: @headers)
      json_body = JSON.parse(response.body)
      if json_body.key?('error')
        json_body
      else
        @login_token = json_body['result']['token']
        @player_id = json_body['result']['player_id']
        @active_worlds = json_body['result']['worlds']['active']
      end
    end

    def enter_world(world_id)
      @world_url = find_world_url(world_id)
      
      site = Tribes::Site::LoginWorld.new(connection: configuration.base_connection,
                                          url: @world_url)
      response = site.download(token: @login_token)
      json_body = JSON.parse(response.body)
      if json_body.key?('invalidsession')
        print "INVALID SESSION\n"
      else
        @sid = json_body['result']['sid']
      end
    end

    def get_villages
      site = Tribes::Site::Villages.new(connection: configuration.base_connection,
                                        url: @world_url)
      response = site.download(sid: @sid)
      json_body = JSON.parse(response.body)
      if json_body.key?('invalidsession')
        print "INVALID SESSION\n"
      else
        print json_body
      end
    end
    # def player_list
    #   @player_list ||= download_player_list
    # end

    # def village_list
    #   @village_list ||= download_village_list
    # end

    # def tribe_list
    #   @tribe_list ||= download_tribe_list
    # end

    # def world_config
    #   @world_config ||= download_world_config
    # end

    # def building_info
    #   @building_info ||= download_building_info
    # end

    # def unit_info
    #   @unit_info ||= download_unit_info
    # end

    private

    def find_world_url(world_id)
      result = ''
      @active_worlds.each do |world|
        result = world['url'] if world['server_name'] == world_id
      end
      result
    end

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
  end
end
