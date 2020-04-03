module Tribes
  module Parser
    def parse_player_list(content)
      content.split(' ').map do |line|
        id, name, tribe_id, village_count, points, rank = line.split(',')
        { name: name, id: id.to_i, tribe_id: tribe_id.to_i, village_count: village_count.to_i,
          points: points.to_i, rank: rank.to_i }
      end
    end

    def parse_village_list(content)
      content.split(' ').map do |line|
        id, name, x, y, player_id, points, rank = line.split(',')
        { id: id.to_i, name: name, x: x.to_i, y: y.to_i,
          player_id: player_id.to_i, points: points.to_i, rank: rank.to_i }
      end
    end
  end
end
