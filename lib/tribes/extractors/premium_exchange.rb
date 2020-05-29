# frozen_string_literal: true

module Tribes
  module Extractors
    class PremiumExchange < Extractor
      def extract(data)
        doc = Nokogiri::HTML(data)
        result = { premium_exchange: {} }
        tables = doc.css('table.premium-exchange')

        result[:premium_exchange][:wood] = extract_premium_table(tables[0], 'wood')
        result[:premium_exchange][:stone] = extract_premium_table(tables[1], 'stone')
        result[:premium_exchange][:iron] = extract_premium_table(tables[2], 'iron')

        result
      end

      private

      def extract_premium_table(table, resource)
        throw "Invalid resource: #{selector}" unless %w[wood stone iron].include?(resource)
        result = {}
        result[:stock] = table.css("td#premium_exchange_stock_#{resource}").text.to_i
        result[:capacity] = table.css("td#premium_exchange_capacity_#{resource}").text.to_i
        quantity = table.css("td#premium_exchange_rate_#{resource} div.premium-exchange-sep").first.text.to_i
        result[:rate] = quantity
        result
      end
    end
  end
end
