# frozen_string_literal: true

module Tribes
  module Extractors
    class VillageData < Extractor
      def extract(data)
        var = /(village = )({[^;]*)/.match(data)
        if var
          { village_data: JSON.parse(var[2].to_s).to_h }
        else
          { village_data: {} }
        end
      end
    end
  end
end
