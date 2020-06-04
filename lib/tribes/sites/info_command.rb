# frozen_string_literal: true

module Tribes
  module Sites
    class InfoCommand < Site
      def initialize(browser)
        super(browser)
        @id = 'info_command'
      end

      def url
        Tribes::URLBuilder.new.https.service('game.php')
                          .add_query_param('screen', 'info_command')
      end

      private

      def set_extractors
        @extractors = [Tribes::Extractors::UnitCounts.new]
      end
    end
  end
end
