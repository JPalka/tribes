# frozen_string_literal: true

module Tribes
  module Sites
    class ScavengingGroups < Extractor
      def extract(data)
        doc = Nokogiri::HTML(data)
        result = { scavenging: {} }
        doc.css('.scavenge-option').each_with_index do |scavenge_option, idx|
          next unless active?(scavenge_option)

          result[:scavenging][idx + 1] = make_info_hash(scavenge_option)
        end
        result
      end

      private

      def active?(node)
        if node.css('.res-label').first.nil? ||
           node.css('.res-label').first.content != 'Collecting Resources'
          return false
        end

        true
      end

      def make_info_hash(node)
        time_left = Tribes.convert_time_str_to_timestamp(node.css('.return-countdown')
                          .first
                          .content)
        time_done = DateTime.now + time_left.seconds
        make_resources_hash(node).merge({ finished_at: time_done.to_time.to_i })
      end

      def make_resources_hash(node)
        wood = node.css('.wood-value').first.content
        stone = node.css('.stone-value').first.content
        iron = node.css('.iron-value').first.content
        { wood: wood, stone: stone, iron: iron }
      end
    end
  end
end
