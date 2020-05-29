# frozen_string_literal: true

module Tribes
  module Questing
    def quest_list
      Server.new(ServiceContainer::GET_QUEST_LIST, @configuration)
            .load([@session.session_id, @session.player_id])
    end

    def quest_finish(quest_id)
      Server.new(ServiceContainer::DO_QUEST_COMPLETE, @configuration)
            .load([@session.session_id,
                   @village_list.selected_element[0],
                   quest_id,
                   false])
    end
  end
end
