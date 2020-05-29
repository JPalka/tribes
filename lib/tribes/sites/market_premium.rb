# frozen_string_literal: true

module Tribes
  module Sites
    class MarketPremium < Site
      def initialize(browser)
        super(browser)
        @id = 'market_premium'
      end

      def url
        Tribes::URLBuilder.new.https.service('game.php')
                          .add_query_param('screen', 'market')
                          .add_query_param('mode', 'exchange')
      end

      def set_extractors
        [Tribes::Extractors::MerchantCounts.new, Tribes::Extractors::TradesPending.new,
         Tribes::Extractors::PremiumExchange.new]
      end
    end
  end
end
