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

      def sell_resources(resource, count)
        @browser.find("input[name='sell_#{resource}'").set(count)
        sleep(1)
        @browser.find('input.btn-premium-exchange-buy').click
        sleep(1)
        final_price, prem = final_rate
        # if block is not given then autoaccept trade no matter what final price is
        if !block_given? || yield(final_price) == true
          @browser.find('button.evt-confirm-btn').click
          clear_inputs
          prem
        else
          @browser.find('button.evt-cancel-btn').click
          sleep(1)
          clear_inputs
          false
        end
      end

      private

      def final_rate
        @browser.find('div#confirmation-msg tr.row_a td:nth-of-type(2)')
                .text
                .scan(/\d+/)
                .map(&:to_i)
      end
    end
  end
end
