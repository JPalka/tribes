# frozen_string_literal: true

module Tribes
  class Server
    MASTER_SERVER = 'master'
    GAME_SERVER = 'game'
    PAYMENT_SERVER = 'pay'
    INVALID_BUILDING = 'nvalid building'
    INVALID_ACTION = 'nvalid action'
    INVALID_VILLAGE = 'nvalid village'
    NO_VILLAGES = 'layer has no villages'
    HANDLE_ERRORS_LOCALLY = 'handleErrorsLocally'
    REQUEST_CONTENT_TIMEOUT_TIME = 7500 # it's in miliseconds I guess?
    REQUEST_ACTION_TIMEOUT_TIME = 10_000
    REQUEST_MAX_RETRIES = 1

    def initialize(service, configuration)
      @service = service
      @configuration = configuration
    end

    def load(data)
      json_data = data.to_json
      response = create_connection(create_url(data)).post do |req|
        req.body = json_data
      end
      json_response = JSON.parse(response.body)
      check_errors(json_response)
      json_response
    end

    def check_errors(data)
      throw 'Error occured woobwoob' if check_error(data)

      throw 'Session is invalid' if check_invalid_session(data)
    end

    private

    def check_error(data)
      data.to_s.include?('error') && !data.to_s.include?('result')
    end

    def check_invalid_session(data)
      data.to_s.downcase.include?('"invalidsession"=>true')
    end

    def create_connection(url)
      Faraday.new(url: url, headers: Headers.new.to_h) do |faraday|
        faraday.use :cookie_jar
        faraday.use FaradayMiddleware::FollowRedirects
        faraday.response :logger
      end
    end

    def create_url(data)
      url_builder = Tribes::URLBuilder.new.https
      handle_service_type(url_builder)
      url_builder.add_query_param('hash', Tribes.calculate_mobile_hash(data)) if data
      url_builder.service(@service.name)
      url_builder.url
    end

    def handle_service_type(builder)
      case @service.server_type
      when GAME_SERVER
        builder.host(@configuration.game_server).game_server_api
      when MASTER_SERVER
        builder.host(@configuration.master_server).master_server_api
      else
        throw 'Error. Invalid service server type'
      end
    end
  end
end
