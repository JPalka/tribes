# frozen_string_literal: true

module Tribes
  module Extractors
    class VillageData < Extractor
      def extract(data)
        var = /(village = )({[^;]*)/.match(data)
        if var
          { villageData: JSON.parse(var[2].to_s).to_h }
        else
          { villageData: {} }
        end
      end
    end
  end
end
