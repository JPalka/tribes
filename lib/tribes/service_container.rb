module Tribes
  class ServiceContainer
    DO_LOGIN_TO_MARKET = DataService.new(ControllerServer::MASTER_SERVER, 'login', 'POST', true)
    DO_LOGIN_TO_WORLD = DataService.new(ControllerServer::GAME_SERVER, 'login', 'POST', true)
    GET_WORLDS = DataService.new(ControllerServer::MASTER_SERVER, 'worlds', 'POST', true)
    GET_VILLAGES = DataService.new(ControllerServer::GAME_SERVER, 'villages_get', 'POST', false)
    GET_VILLAGE_DATA = DataService.new(ControllerServer::GAME_SERVER, 'village_data', 'POST', false)
    GET_PLAYER_INFO = DataService.new(ControllerServer::GAME_SERVER, 'player_info', 'POST', false)
    GET_VILLAGE_VISUAL = DataService.new(ControllerServer::GAME_SERVER, 'village_visual', 'POST', false)
    GET_PROD_BUILDING = DataService.new(ControllerServer::GAME_SERVER, 'prod_building', 'POST', false)
  end
end
