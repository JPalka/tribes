module Tribes
  class ServiceContainer
    DO_LOGIN_TO_MARKET = DataService.new(ControllerServer::MASTER_SERVER, 'login', 'POST', true)
    DO_LOGIN_TO_WORLD = DataService.new(ControllerServer::GAME_SERVER, 'login', 'POST', true)
    GET_WORLDS = DataService.new(ControllerServer::MASTER_SERVER, 'worlds', 'POST', true)
    GET_VILLAGES = DataService.new(ControllerServer::GAME_SERVER, 'villages_get', 'POST', false)
  end
end