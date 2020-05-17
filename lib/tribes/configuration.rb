# frozen_string_literal: true

module Tribes
  class Client
    class Configuration
      ATTRIBUTES = %i[login password master_server game_server].freeze
      attr_accessor :login, :password, :game_server, :master_server

      def initialize
        @master_server = 'https://www.tribalwars.net'
        @game_server = ''
        @login = 'korenchkin'
        @password = 'rickenbacker1'
      end

      def merge(options)
        unpermitted_options = options.keys.map(&:to_sym) - ATTRIBUTES
        if unpermitted_options.any?
          raise ArgumentError, "Invalid options: #{unpermitted_options.join(', ')}"
        end

        options.each { |option, value| send("#{option}=", value) }

        self
      end
    end
  end
end
