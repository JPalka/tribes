# frozen_string_literal: true

module Tribes
  module Recruitment
    def recruit_info(building_id = 'all')
      Server.new(ServiceContainer::GET_RECRUITMENT_UNITS, @configuration)
            .load([@session.session_id, @village_list.selected_element[0], building_id])
    end

    def recruit_unit(unit_id, building_id, quantity)
      Server.new(ServiceContainer::DO_RECRUITMENT_RECRUIT, @configuration)
            .load([@session.session_id,
                   @village_list.selected_element[0],
                   building_id,
                   unit_id,
                   quantity.to_i])
    end

    def recruit_cancel(building_id, order_id)
      Server.new(ServiceContainer::DO_RECRUITMENT_CANCEL, @configuration)
            .load([@session.session_id,
                   @village_list.selected_element[0],
                   building_id,
                   order_id])
    end
  end
end
