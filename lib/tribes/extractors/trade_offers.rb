# frozen_string_literal: true

module Tribes
  module Extractors
    class TradeOffers < Extractor
      def extract(data)
        doc = Nokogiri::HTML(data)
        result = { trades: [] }
        trades_rows = doc.css('#content_value > table > tbody > tr > td > table:last-child tr')
        trades_rows.drop(3).each_slice(2) do |row_info, row_form|
          result[:trades].push(extract_trade_offer(row_info, row_form))
        end

        result
      end

      private

      def extract_trade_offer(row_info, row_form)
        info_cells = row_info.css('td')
        trade_offer = {}
        trade_offer[:receive] = extract_resource(info_cells[0])
        trade_offer[:send] = extract_resource(info_cells[1])
        trade_offer[:ratio] = info_cells[2].text.to_i
        trade_offer[:duration] = Tribes.convert_time_str_to_timestamp(info_cells[3].text)
        trade_offer[:count] = info_cells[4].text.to_i

        trade_offer[:id] = row_form.css('input[name="id"]').attr('value').value
        trade_offer
      end
    end
  end
end
