# frozen_string_literal: true

module Tribes
  class VillageList < DataList
    def initialize(configuration)
      super(configuration)
      @controller = ControllerServer.new(ServiceContainer::GET_VILLAGES, @configuration)
    end

    def load(json_data)
      @list = json_data['villages_in_current_group']
      @selected_element = json_data['default_village']
    end
    
    private

    def post_data(session)
      [session.session_id, @selected_element.to_h['id']]
    end
  end
end
