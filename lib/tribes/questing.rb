# frozen_string_literal: true

module Tribes
  module Questing
    def quest_list
      Server.new(ServiceContainer::GET_QUEST_LIST, @configuration)
            .load([@session.session_id, @session.player_id])
    end

    def quest_complete; end
  end
end
