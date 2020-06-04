# frozen_string_literal: true

module Tribes
  module Extractors
    class Outgoings < Extractor
      def extract(data)
        doc = Nokogiri::HTML(data)
        result = { outgoings: [] }
        commands = doc.css('div#commands_outgoings tr.command-row')
        commands.each do |command|
          id = command.css('span.command_hover_details').attr('data-command-id').value.to_i
          type = command.css('span.command_hover_details').attr('data-command-type').value
          finish_time = command.css('span[data-endtime]').attr('data-endtime').value.to_i
          result[:outgoings].push({ id: id, type: type, finished_at: finish_time })
        end
        result
      end
    end
  end
end
