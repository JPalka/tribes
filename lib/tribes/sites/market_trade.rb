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
        [Tribes::Extractors::MerchantCounts.new]
      end

      def trades(want, offer, time_limit = 96)
        setup(want, offer, time_limit)
      end

      private

      def setup(want, offer, time_limit)
        @browser.find("input:not([clicked])[name=\"res_sell\"][value=\"#{want}\"]").click
        sleep(1)
        @browser.find("input:not([clicked])[name=\"res_buy\"][value=\"#{offer}\"]").click
        sleep(1)
        @browser.find("option[value='#{time_limit}']").select_option
      end
    end
  end
end
