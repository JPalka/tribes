# frozen_string_literal: true

module Tribes
  module Extractors
    class TradesPending < Extractor
      def extract(data)
        doc = Nokogiri::HTML(data)
        result = { trades_pending: {} }
        rows = doc.css('div#market_status_bar table tr').drop(2)
        result[:trades_pending][:incoming] = extract_resource(rows[0].css('td'))
        result[:trades_pending][:outgoing] = extract_resource(rows[1].css('td'))
        result
      end
    end
  end
end
