# frozen_string_literal: true

module Tribes
  module Sites
    class PlayerList < Site
      def initialize(browser)
        super(browser)
        @id = 'player_list'
      end

      def url
        Tribes::URLBuilder.new.https.service('map/player.txt')
      end

      def set_extractors
        [Tribes::Extractors::PlayersCsv.new]
      end
    end
  end
end
