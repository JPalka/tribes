# frozen_string_literal: true

module Tribes
  module Sites
    class Smithy < Site
      def initialize(browser)
        super(browser)
        @id = 'smithy'
      end

      def url
        Tribes::URLBuilder.new.https.service('game.php')
                          .add_query_param('screen', 'smith')
      end

      def set_extractors
        [Tribes::Extractors::Tech.new]
      end
    end
  end
end
