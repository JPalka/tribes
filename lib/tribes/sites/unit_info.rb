# frozen_string_literal: true

module Tribes
  module Sites
    class UnitInfo < Site
      def initialize(browser)
        super(browser)
        @id = 'unit_info'
      end

      def url
        Tribes::URLBuilder.new.https.service('interface.php').add_query_param('func', 'get_unit_info')
      end

      def set_extractors
        [Tribes::Extractors::ConfigXml.new]
      end
    end
  end
end
