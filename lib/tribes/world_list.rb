module Tribes
  class WorldList
    def initialize(configuration)
      @worlds = []
      @active_worlds = [] # worlds that you are already playing on

      @selected_world = nil
      @configuration = configuration
    end

    def download_worlds(session)
      controller = ControllerServer.new(ServiceContainer::GET_WORLDS, @configuration)
      json_response = controller.load([session.token])
      if controller.check_error(json_response)
        throw 'Error occured woobwoob'
      elsif controller.check_invalid_session(json_response)
        throw 'Session is invalid'
      else
        load_worlds(json_response['result'])
        json_response
      end
    end

    def load_worlds(json_data)
      json_data.each do |world_group, _val|
        next if world_group == 'current'

        json_data[world_group].each do |world|
          @worlds.push(world)
        end
      end
    end
  end
end