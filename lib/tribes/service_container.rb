# frozen_string_literal: true

module Tribes
  class ServiceContainer
    DO_LOGIN_TO_MARKET = DataService.new(ControllerServer::MASTER_SERVER, 'login', 'POST', true)
    DO_LOGIN_TO_WORLD = DataService.new(ControllerServer::GAME_SERVER, 'login', 'POST', true)

    GET_WORLDS = DataService.new(ControllerServer::MASTER_SERVER, 'worlds', 'POST', false)
    GET_VILLAGES = DataService.new(ControllerServer::GAME_SERVER, 'villages_get', 'POST', false)
    GET_VILLAGE_DATA = DataService.new(ControllerServer::GAME_SERVER, 'village_data', 'POST', false)
    GET_PLAYER_INFO = DataService.new(ControllerServer::GAME_SERVER, 'player_info', 'POST', false)
    GET_VILLAGE_VISUAL = DataService.new(ControllerServer::GAME_SERVER, 'village_visual', 'POST', false)
    GET_PROD_BUILDING = DataService.new(ControllerServer::GAME_SERVER, 'prod_building', 'POST', false)
    GET_MAIN_INFO = DataService.new(ControllerServer::GAME_SERVER, 'main_construction_info', 'POST', false)
    GET_MAIN_DOWNGRADES = DataService.new(ControllerServer::GAME_SERVER, 'main_downgrades', 'POST', false)
    GET_MAIN_UPGRADE_INFO = DataService.new(ControllerServer::GAME_SERVER, 'main_upgrade_info', 'POST', false)
    GET_RECRUITMENT_UNITS = DataService.new(ControllerServer::GAME_SERVER, 'train_building', 'POST', false)
    GET_GAME_DATA = DataService.new(ControllerServer::GAME_SERVER, 'heartbeat', 'POST', false)
    GET_REPORTS = DataService.new(ControllerServer::GAME_SERVER, 'reports_get_reports', 'POST', false)
    GET_REPORT = DataService.new(ControllerServer::GAME_SERVER, 'reports_fetch_report', 'POST', false)
    GET_REPORT_GROUPS = DataService.new(ControllerServer::GAME_SERVER, 'reports_delete', 'POST', false)
    GET_MAILS = DataService.new(ControllerServer::GAME_SERVER, 'mail_get_mails', 'POST', false)
    GET_MAIL_GROUPS = DataService.new(ControllerServer::GAME_SERVER, 'mail_groups', 'POST', false)
    GET_MAIL = DataService.new(ControllerServer::GAME_SERVER, 'mail_fetch_mail', 'POST', false)
    GET_MAP_DATA = DataService.new(ControllerServer::GAME_SERVER, 'map', 'POST', false)
    GET_QUEST_LIST = DataService.new(ControllerServer::GAME_SERVER, 'quests_list', 'POST', false)
    GET_LOCALIZED_LINK = DataService.new(ControllerServer::GAME_SERVER, 'localized_link', 'POST', false)
  end
end
