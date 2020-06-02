# frozen_string_literal: true

module Tribes
  module Extractors
    class UnitCounts < Extractor
      def extract(data)
        doc = Nokogiri::HTML(data)
        result = { units: {} }
        result[:units][:available] =
          doc.css('a.units-entry-all').each_with_object({}) do |link, hash|
            hash[link.attr('data-unit')] = link.content.tr('()', '').to_i
          end
        extract_village_overview(data, result)
        result
      end

      private

      def extract_village_overview(data, result)
        own = /(VillageOverview.units\[1\] = )({[^;]*)/.match(data)
        supports = /(VillageOverview.units\[2\] = )({[^;]*)/.match(data)

        temp = map_unit_count(parse_json_var(own))
        temp_sup = map_unit_count(parse_json_var(supports))
        result[:units][:available] = temp if temp
        result[:units][:supports] = temp_sup if temp_sup
      end

      def map_unit_count(arr)
        arr.map { |key, val| [key, val['count'].to_i] }.to_h if arr
      end

      def parse_json_var(var)
        JSON.parse(var[2].to_s).to_h if var
      end
    end
  end
end
