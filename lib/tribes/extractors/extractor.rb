# frozen_string_literal: true

module Tribes
  module Extractors
    class Extractor
      def extract(data); end

      private

      def extract_village_json(data)
        JSON.parse(/(village = )({[^;]*)/.match(data)[2].to_s)
      end

      # Extract type and quantity of resource from table cell
      def extract_resource(td)
        regular_res = td.css('span.nowrap')
        result = {}
        # assigno di regularo resourcino: woodini, stonello, ironini
        regular_res.each do |span|
          resource = {}
          resource[:amount] = span.text.gsub('.', '').to_i
          resource[:id] = span.css('span.icon').first.classes[2] if td.css('span.icon').first
          result[resource[:id]] = resource[:amount] if resource[:amount].positive?
        end
        # handlino premiumo pointes
        resource = {}
        resource[:amount] = td.xpath('text()').text.to_i
        resource[:id] = td.css('> span.icon').first.classes[2] if td.css('> span.icon').first
        result[resource[:id]] = resource[:amount] if resource[:amount].positive?
        result
      end
    end
  end
end
