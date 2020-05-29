# frozen_string_literal: true

module Tribes
  module Sites
    class FlagsIndex < Site
      def initialize(browser)
        super(browser)
        @id = 'flags_index'
      end

      def url
        Tribes::URLBuilder.new.https.service('game.php')
                          .add_query_param('screen', 'flags')
                          .add_query_param('mode', 'index')
      end

      def set_extractors
        [Tribes::Extractors::Flags.new]
      end
    end
  end
end
