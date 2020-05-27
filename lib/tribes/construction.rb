# frozen_string_literal: true

module Tribes
  module Construction
    def upgrade_building(building_id)
      Server.new(ServiceContainer::DO_MAIN_UPGRADE, @configuration)
            .load([@session.session_id, @village_list.selected_element[0], building_id])
    end

    def upgrade_cancel(order_id)
      Server.new(ServiceContainer::DO_MAIN_CANCEL, @configuration)
            .load([@session.session_id,
                   @village_list.selected_element[0],
                   order_id.to_i])
    end

    def upgrade_info(building_id)
      Server.new(ServiceContainer::GET_MAIN_UPGRADE_INFO, @configuration)
            .load([@session.session_id, @village_list.selected_element[0], building_id])
    end

    def construction_info
      Server.new(ServiceContainer::GET_MAIN_INFO, @configuration)
            .load([@session.session_id, @village_list.selected_element[0]])
    end

    def downgrade_info
      Server.new(ServiceContainer::GET_MAIN_DOWNGRADES, @configuration)
            .load([@session.session_id, @village_list.selected_element[0]])
    end
  end
end
