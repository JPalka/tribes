# frozen_string_literal: true

module Tribes
  module Extractors
    class MerchantCounts < Extractor
      def extract(data)
        doc = Nokogiri::HTML(data)
        result = { merchants: {} }
        result[:merchants][:available] = doc.css('span#market_merchant_available_count')
                                            .first
                                            .content
                                            .to_i
        result[:merchants][:total] = doc.css('span#market_merchant_total_count')
                                        .first
                                        .content
                                        .to_i
        result
      end
    end
  end
end
