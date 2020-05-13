module Tribes {
  class DataService
    attr_reader :server_type, :name, :method, :is_action_request
    
    def initialize(server_type, name, method, is_action_request)
      @server_type = server_type
      @name = name
      @method = method
      @is_action_request = is_action_request
    end
  end
}