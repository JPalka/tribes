# frozen_string_literal: true

module Tribes
  module Sites
    class MarketTrade < Site
      def initialize(browser)
        super(browser)
        @id = 'market_trade'
      end

      def url
        Tribes::URLBuilder.new.https.service('game.php')
                          .add_query_param('screen', 'market')
                          .add_query_param('mode', 'other_offer')
      end

      def set_extractors
        []
      end
    end
  end
end
