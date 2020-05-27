# frozen_string_literal: true

module Tribes
  module Sites
    class WorldConfig < Site
      def initialize(browser)
        super(browser)
        @id = 'world_config'
      end

      def url
        Tribes::URLBuilder.new.https.service('interface.php').add_query_param('func', 'get_config')
      end

      def set_extractors
        [ConfigXml.new]
      end
    end
  end
end
