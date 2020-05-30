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
        result[:active_flag] = flag_from_img(doc.css('div#current_flag img').attr('src'))
        result
      end

      private

      # behold! extracting flag flag level and category from icon src because
      # its nowhere to be found. Possible PITA.
      # https://dsen.innogamescdn.com/asset/3cc5e90/graphic/flags/medium/1_5.png
      def flag_from_img(img_src)
        _crap, category, level = /([1-9])_([1-9])/.match(img_src).to_a
        { Tribes::FLAG_CATEGORIES[category.to_i] => level }
      end

      def extract_flag_info(div)
        div.css('.flag_count').text.to_i
      end
    end
  end
end
