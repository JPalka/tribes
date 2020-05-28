# frozen_string_literal: true

module Tribes
  module Sites
    class TribeList < Site
      def initialize(browser)
        super(browser)
        @id = 'tribe_list'
      end

      def url
        Tribes::URLBuilder.new.https.service('map/ally.txt')
      end

      def set_extractors
        [Tribes::Extractors::TribesCsv.new]
      end
    end
  end
end
