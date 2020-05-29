# frozen_string_literal: true

module Tribes
  module Sites
    class MarketMerchants < Site
      def initialize(browser)
        super(browser)
        @id = 'market_merchants'
      end

      def url
        Tribes::URLBuilder.new.https.service('game.php')
                          .add_query_param('screen', 'market')
                          .add_query_param('mode', 'traders')
      end

      def set_extractors
        [Tribes::Extractors::MerchantCounts.new, Tribes::Extractors::TradesPending.new]
      end
    end
  end
end
