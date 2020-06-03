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

    def report(report_id, filter = 'all', group = 0, village_id = @village_list.selected_element[0])
      Server.new(ServiceContainer::GET_REPORT, @configuration)
            .load([@session.session_id,
                   report_id,
                   filter,
                   group,
                   village_id])
    end
  end
end
