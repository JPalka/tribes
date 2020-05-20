# frozen_string_literal: true

module Tribes
  module Sites
    class VillageData < Extractor
      def extract(data)
        { villageData: JSON.parse(/(village = )({[^;]*)/.match(data)[2].to_s).to_h }
      end
    end
  end
end
