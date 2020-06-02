# frozen_string_literal: true

module Tribes
  module Extractors
    class Tech < Extractor
      def extract(data)
        result = { tech: JSON.parse(/(BuildingSmith\.techs = )({[^;]*)/.match(data)[2].to_s).to_h }
        result[:tech].each do |_key, val|
          val.each do |_unit, info|
            if info.key?('research_time')
              info['research_time'] = Tribes.convert_time_str_to_timestamp(info['research_time'])
            end
          end
        end
      end
    end
  end
end
