# frozen_string_literal: true

module Tribes
  module Sites
    class VillagesCsv < Extractor
      def extract(data)
        doc = Nokogiri::HTML(data)
        villages = doc.css('pre').first.content.split(' ').map do |line|
          id, name, x, y, player_id, points, rank = line.split(',')
          { id: id.to_i, name: name, x: x.to_i, y: y.to_i,
            player_id: player_id.to_i, points: points.to_i, rank: rank.to_i }
        end
        { villages: villages }
      end
    end
  end
end
