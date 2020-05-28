# frozen_string_literal: true

module Tribes
  module Extractors
    class TribesCsv < Extractor
      def extract(data)
        doc = Nokogiri::HTML(data)
        tribes = doc.css('pre').first.content.split(' ').map do |line|
          id, name, tag, member_count, village_count, points_top, points, rank = line.split(',')
          { id: id.to_i, name: name, tag: tag, member_count: member_count.to_i,
            village_count: village_count.to_i, points_top: points_top.to_i,
            points: points.to_i, rank: rank.to_i }
        end
        { tribes: tribes }
      end
    end
  end
end
