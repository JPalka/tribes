# frozen_string_literal: true

module Tribes
  module Sites
    class PlayersCsv < Extractor
      def extract(data)
        doc = Nokogiri::HTML(data)
        players = doc.css('pre').first.content.split(' ').map do |line|
          id, name, tribe_id, village_count, points, rank = line.split(',')
          { name: name, id: id.to_i, tribe_id: tribe_id.to_i, village_count: village_count.to_i,
            points: points.to_i, rank: rank.to_i }
        end
        { players: players }
      end
    end
  end
end
