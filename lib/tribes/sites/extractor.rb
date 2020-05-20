# frozen_string_literal: true

module Tribes
  module Sites
    class Extractor
      def extract(data); end

      private

      def extract_village_json(data)
        JSON.parse(/(village = )({[^;]*)/.match(data)[2].to_s)
      end
    end
  end
end
