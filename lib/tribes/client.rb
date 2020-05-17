# frozen_string_literal: true

module Tribes
  class Client
    include Tribes::Parser
    attr_reader :active_worlds

    def initialize(options = {})
      @configuration = Configuration.new
      @configuration.merge(options)
      @session = Session.new(@configuration)
      @world_list = WorldList.new(@configuration)
      @village_list = VillageList.new(@configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
      configuration
    end

    def worlds
      @world_list.download(@session)
    end

    def login
      response = @session.login_to_market(@configuration.login, @configuration.password)
      @world_list.load(response['result']['worlds'])
    end

    def login_to_world
      throw 'Choose a fucking world' unless @configuration.game_server

      @session.login_to_world
    end

    def villages
      throw 'Not logged in' unless @session.player_id

      @village_list.download(@session)
    end

    def village_data
      controller = ControllerServer.new(ServiceContainer::GET_VILLAGE_DATA, @configuration)
      json_response = controller.load([@session.session_id, @village_list.selected_element[0]])
      json_response
    end

    def village_visual
      controller = ControllerServer.new(ServiceContainer::GET_VILLAGE_VISUAL, @configuration)
      json_response = controller.load([@session.session_id, @village_list.selected_element[0]])
      json_response
    end

    def player_info
      controller = ControllerServer.new(ServiceContainer::GET_PLAYER_INFO, @configuration)
      json_response = controller.load([@session.session_id, @session.player_id])
      json_response
    end

    def prod_building(building_id)
      throw 'wrong building type.' unless %w[wood iron clay].include?(building_id)

      controller = ControllerServer.new(ServiceContainer::GET_PROD_BUILDING, @configuration)
      json_response = controller.load([@session.session_id,
                                       @village_list.selected_element[0],
                                       building_id.to_s])
      json_response
    end

    def change_world(world_id)
      new_world = @world_list.select(world_id)
      if new_world
        @configuration.game_server = new_world['url']
        true
      else
        false
      end
    end

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
