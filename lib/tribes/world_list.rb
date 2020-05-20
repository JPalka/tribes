# frozen_string_literal: true

module Tribes
  class WorldList < DataList
    def initialize(configuration)
      super(configuration)
      @controller = Server.new(ServiceContainer::GET_WORLDS, @configuration)
    end

    def load(json_data)
      json_data.each do |world_group, _val|
        next if world_group == 'current'

        json_data[world_group].each do |world|
          world['url'].gsub!('https://', '')
          @list.push(world)
        end
      end
    end

    def select(world_id)
      # yeet if world is already selected
      return false if world_id == @selected_element.to_h['server_name']

      found_world = @list.find { |world| world['server_name'] == world_id }
      return false unless found_world

      @selected_element = found_world
    end

    private

    def post_data(session)
      [session.token]
    end
  end
end
