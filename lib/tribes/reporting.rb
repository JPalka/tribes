# frozen_string_literal: true

module Tribes
  module Reporting
    def reports(filter = 'all', group = 0, page = 0, page_size = 25)
      Server.new(ServiceContainer::GET_REPORTS, @configuration)
            .load([@session.session_id,
                   filter,
                   group,
                   page,
                   page_size])
    end
  end
end
