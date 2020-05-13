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
    REQUEST_CONTENT_TIMEOUT_TIME = 7500 #it's in miliseconds I guess?
    REQUEST_ACTION_TIMEOUT_TIME = 10000
    REQUEST_MAX_RETRIES = 1
    
    def initialize(service, configuration, connection)
      @service = service
      @configuration = configuration
      @connection = connection
    end

    def load(data)
      json_data = data.to_json
      hash = Tribes.calculate_mobile_hash(json_data)
      slug = ''
      if (@service.server_type == GAME_SERVER || @_service.server_type == MASTER_SERVER)
        slug += '?hash=' + Tribes.calculate_mobile_hash(json_data)
      end
      base_url = ''
      case @service.server_type
      when GAME_SERVER
        base_url = @configuration.game_server + 'm/g/'
      when MASTER_SERVER
        base_url = @configuration.master_server + 'm/m/'
      else
        throw 'Error. Invalid service server type'
      end
      @connection.post(base_url + slug) do |req|
        req.body = json_data
      end
    end
  end
end