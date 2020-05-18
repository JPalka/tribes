# frozen_string_literal: true

module Tribes
  class Client
    include Tribes::Parser

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
      controller.load([@session.session_id, @village_list.selected_element[0]])
    end

    def village_visual
      controller = ControllerServer.new(ServiceContainer::GET_VILLAGE_VISUAL, @configuration)
      controller.load([@session.session_id, @village_list.selected_element[0]])
    end

    def player_info
      controller = ControllerServer.new(ServiceContainer::GET_PLAYER_INFO, @configuration)
      controller.load([@session.session_id, @session.player_id])
    end

    def prod_building(building_id)
      throw 'wrong building type.' unless %w[wood iron clay].include?(building_id)

      controller = ControllerServer.new(ServiceContainer::GET_PROD_BUILDING, @configuration)
      controller.load([@session.session_id, @village_list.selected_element[0], building_id.to_s])
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
  end
end
