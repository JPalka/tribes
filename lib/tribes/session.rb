module Tribes
  class Session
    attr_reader :token
    def initialize(configuration)
      @market_key = 'zz'
      @username = ''
      @password = ''
      @token = ''
      @player_id = ''
      @login_url = ''
      @session_id = ''
      @configuration = configuration
    end

    def login_to_market(username, password)
      controller = ControllerServer.new(ServiceContainer::DO_LOGIN_TO_MARKET, @configuration)
      json_response = controller.load([username, password, '2.30.0'])
      controller.check_errors(json_response)
      login_to_market_success(json_response)
      end
    end

    def login_to_world
      controller = ControllerServer.new(ServiceContainer::DO_LOGIN_TO_WORLD, @configuration)
      json_response = controller.load([@token, 2, 'android'])
      controller.check_errors(json_response)
      login_to_world_success(json_response)
      json_response
    end

    private

    def login_to_market_success(json_response)
      @username = json_response['result']['name']
      @token = json_response['result']['token']
      @player_id = json_response['result']['player_id']
      # @active_worlds = json_response['result']['worlds']['active']
      json_response
    end

    def login_to_world_success(json_response)
      @session_id = json_response['result']['sid']
      @login_url = json_response['result']['login_url']
      # just visit login link to make sure we are logged in. Dunno if its needed
      connection = Faraday.new(url: @login_url, headers: Headers.new.to_h) do |faraday|
        faraday.use :cookie_jar
        faraday.response :logger
      end
      req1 = connection.get
      req2 = connection.get(@configuration.game_server + '/' + req1.headers['location'])
    end
  end
end