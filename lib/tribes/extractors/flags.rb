# frozen_string_literal: true

module Tribes
  module Extractors
    class Flags < Extractor
      def extract(data)
        doc = Nokogiri::HTML(data)
        result = { flags: {} }
        flag_containers = doc.css('div#flags_container')
        flag_containers.each_with_index do |container, idx|
          flags = container.css('div.flag_box')
          result[:flags][Tribes::FLAG_CATEGORIES[idx + 1]] =
            flags.map do |flag|
              extract_flag_info(flag)
            end
        end
        result
      end

      private

      def extract_flag_info(div)
        div.css('.flag_count').text.to_i
      end
    end
  end
end
