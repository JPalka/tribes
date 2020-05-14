module Tribes 
  class ControllerServer
    MASTER_SERVER = 'master'
    GAME_SERVER = 'game'
    PAYMENT_SERVER = 'pay'
    INVALID_BUILDING = 'nvalid building'
    INVALID_ACTION = 'nvalid action'
    INVALID_VILLAGE = 'nvalid village'
    NO_VILLAGES = 'layer has no villages'
    HANDLE_ERRORS_LOCALLY = 'handleErrorsLocally'
    REQUEST_CONTENT_TIMEOUT_TIME = 7500 # it's in miliseconds I guess?
    REQUEST_ACTION_TIMEOUT_TIME = 10000
    REQUEST_MAX_RETRIES = 1
    
    def initialize(service, configuration)
      @service = service
      @configuration = configuration
    end

    def load(data)
      json_data = data.to_json
      connection = Faraday.new(url: create_base_url, headers: Headers.new.to_h) do |faraday|
        faraday.use FaradayMiddleware::FollowRedirects
        faraday.response :logger
      end
      response = connection.post(@service.name + create_slug(data)) do |req|
        req.body = json_data
      end
      JSON.parse(response.body)
    end

    def check_error(data)
      data.to_s.include?('error') && !data.to_s.include?('result')
    end

    def check_invalid_session(data)
      data.to_s.downcase.include?('"invalidsession"=>true')
    end

    private

    def create_slug(data)
      slug = ''
      if @service.server_type == GAME_SERVER || @service.server_type == MASTER_SERVER
        slug += '?hash=' + Tribes.calculate_mobile_hash(data)
      end
      slug
    end
    
    def create_base_url
      base_url = ''
      case @service.server_type
      when GAME_SERVER
        base_url = @configuration.game_server + '/m/g/'
      when MASTER_SERVER
        base_url = @configuration.master_server + '/m/m/'
      else
        throw 'Error. Invalid service server type'
      end
      base_url
    end
  end
end
