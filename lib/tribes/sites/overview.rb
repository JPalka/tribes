# frozen_string_literal: true

module Tribes
  module Sites
    class Overview < Site
      def initialize(browser)
        super(browser)
        @id = 'overview'
      end

      def url
        Tribes::URLBuilder.new.https.service('game.php')
                          .add_query_param('screen', 'overview')
      end

      private

      def set_extractors
        [Tribes::Extractors::VillageData.new, Tribes::Extractors::UnitCounts.new]
      end
    end
  end
end
