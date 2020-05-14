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
      controller.check_errors(json_response)
      load_worlds(json_response['result'])
      json_response
    end

    def load_worlds(json_data)
      json_data.each do |world_group, _val|
        next if world_group == 'current'

        json_data[world_group].each do |world|
          @worlds.push(world)
        end
      end
    end

    def change_world(world_id)
      # yeet if world is already selected
      return false if world_id == @selected_world.to_h['server_name']

      found_world = @worlds.find { |world| world['server_name'] == world_id }
      return false unless found_world

      @selected_world = found_world
    end
  end
end