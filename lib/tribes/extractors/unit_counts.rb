# frozen_string_literal: true

module Tribes
  module Extractors
    class UnitCounts < Extractor
      def extract(data)
        doc = Nokogiri::HTML(data)
        result = { units: {} }
        result[:units][:available] =
          doc.css('a.units-entry-all').each_with_object({}) do |link, hash|
            hash[link.attr('data-unit')] = link.content.tr('()', '')
          end
        result
      end
    end
  end
end
