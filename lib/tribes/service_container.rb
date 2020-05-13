module Tribes
  class ServiceContainer
    DO_LOGIN_TO_MARKET = DataService.new(ControllerServer::MASTER_SERVER, 'login', 'POST', true)
  end
end