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
      if json_response.key?('error')
        throw 'Error occured woobwoob'
      else
        login_to_market_success(json_response)
      end
    end

    private

    def login_to_market_success(json_response)
      @username = json_response['result']['name']
      @token = json_response['result']['token']
      @player_id = json_response['result']['player_id']
      # @active_worlds = json_response['result']['worlds']['active']
      json_response
    end
  end
end