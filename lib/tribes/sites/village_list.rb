# frozen_string_literal: true

module Tribes
  module Sites
    class VillageList < Site
      def initialize(browser)
        super(browser)
        @id = 'village_list'
      end

      def url
        Tribes::URLBuilder.new.https.service('map/village.txt')
      end

      def set_extractors
        [VillagesCsv.new]
      end
    end
  end
end
