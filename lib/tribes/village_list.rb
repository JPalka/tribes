# frozen_string_literal: true

module Tribes
  class VillageList
    attr_reader :active_village, :villages
    def initialize(configuration)
      @configuration = configuration
      @active_village = nil
      @villages = []
    end

    def download_villages(session)
      controller = ControllerServer.new(ServiceContainer::GET_VILLAGES, @configuration)
      json_response = controller.load([session.session_id, @active_village.to_h['id']])
      controller.check_errors(json_response)
      load_villages(json_response['result'])
      json_response
    end

    def load_villages(json_data)
      @villages = json_data['villages_in_current_group']
      @active_village = json_data['default_village']
    end
  end
end
