# frozen_string_literal: true

module Tribes
  class Client
    attr_reader :browser
    include Tribes::Parser
    include Tribes::Recruitment
    include Tribes::Construction
    include Tribes::Questing
    include Tribes::Reporting

    def initialize(options = {})
      @configuration = Configuration.new
      @configuration.merge(options)
      @session = Session.new(@configuration)
      @world_list = WorldList.new(@configuration)
      @village_list = VillageList.new(@configuration)
      @browser = Browser.new(@session, @configuration, @village_list)
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
      return { error: 'Choose a fucking world' } unless @configuration.game_server

      @session.login_to_world(@browser)
    end

    def villages
      return { error: 'Not logged in' } unless @session.player_id

      @village_list.download(@session)
    end

    def worlds_global
      Tribes::Extractors::Wtf.new.extract(
        Server.new(ServiceContainer::GET_WORLDS_GLOBAL, @configuration).load('')
      )
    end

    def village_data
      Server.new(ServiceContainer::GET_VILLAGE_DATA, @configuration)
            .load([@session.session_id, @village_list.selected_element[0]])
    end

    def village_visual
      Server.new(ServiceContainer::GET_VILLAGE_VISUAL, @configuration)
            .load([@session.session_id, @village_list.selected_element[0]])
    end

    def player_info
      Server.new(ServiceContainer::GET_PLAYER_INFO, @configuration)
            .load([@session.session_id, @session.player_id])
    end

    def heartbeat
      Server.new(ServiceContainer::GET_GAME_DATA, @configuration)
            .load([@session.session_id, 0])
    end

    def map
      Server.new(ServiceContainer::GET_MAP_DATA, @configuration)
            .load([@session.session_id, @village_list.selected_element[0]])
    end

    def prod_building(building_id)
      return { error: 'wrong building type.' } unless %w[wood iron clay].include?(building_id)

      Server.new(ServiceContainer::GET_PROD_BUILDING, @configuration)
            .load([@session.session_id, @village_list.selected_element[0], building_id.to_s])
    end

    def change_world(world_id, world_url: nil)
      new_world = @world_list.select(world_id)
      if new_world
        @configuration.game_server = new_world['url']
        true
      elsif world_url
        @configuration.game_server = world_url
      else
        false
      end
    end
  end
end
