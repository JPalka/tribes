module Tribes
  class WorldList
    def initialize(configuration)
      @worlds = []
      @selected_world = nil
      @configuration = configuration
    end

    def download_worlds
      controller = ControllerServer.new(ServiceContainer::GET_WORLDS, @configuration)
      json_response = controller.load()
      if json_response.key?('error')
        throw 'Error occured woobwoob'
      else
        json_response
      end
    end
  end
end