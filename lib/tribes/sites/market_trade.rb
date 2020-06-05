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
        [Tribes::Extractors::MerchantCounts.new, Tribes::Extractors::TradeOffers.new]
      end

      def trades(want, offer, time_limit = 96)
        setup(want, offer, time_limit)
      end

      def trade(trade_id, count)
        form = find_offer(trade_id)
        form.find("input[name='count']").set(count)
        sleep(1)
        form.find("input[type='submit']").click

        begin
          error = @browser.find('div.error_box div.content').text
          { error: error }
        rescue Capybara::ElementNotFound
          true
        end
      end

      private

      def find_offer(trade_id)
        @browser.find("input[name='id'][value='#{trade_id}']", visible: false).first(:xpath, './/..')
      rescue Capybara::ElementNotFound
        { error: "Trade offer #{trade_id} not found" }
      end

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
