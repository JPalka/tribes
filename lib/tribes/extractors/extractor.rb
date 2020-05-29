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
        resource = { id: 'shitgarbage', amount: 0 }
        resource[:amount] = td.css('span.nowrap').text.gsub('.', '').to_i
        resource[:id] = td.css('span.nowrap span.icon').first.classes[2]
        resource
      end
    end
  end
end
