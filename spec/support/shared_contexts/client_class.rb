# frozen_string_literal: true

RSpec.shared_context 'client class' do
  let(:client) do
    described_class.new.tap { |client_class| client_class.configuration.merge(options) }
  end
  let(:options) { {} }
  let(:instance) { client }
  let(:players) do
    "898,piratedan,1023,1,1347,1644\n"\
    "7297,darkx,85,3,6594,88\n"\
    "10083,zora+ostar,1060,1,916,2569\n"\
    "15035,DrakenZ,328,1,506,4317\n"\
    "17977,Tyrungal,104,1,1158,1961\n"\
    '24949,FeudalKnight,0,1,242,6836'
  end
  let(:villages) do
    "1,%2B+KINGS+CASTLE+%2B,500,476,267865,1533,0\n"\
    "2,001,502,472,9828389,3170,0\n"\
    "3,335D,507,482,11295245,2388,0\n"
  end
  let(:tribes) do
    "2,Zini,Zanzo,1,1,486,486,169\n"\
    "7,Lions+of+the+Night,Lions,3,3,4571,4571,111\n"\
    "9,Cerberus,Hades,11,32,147555,147555,31\n"
  end

  let(:world_config) { File.new('spec/fixtures/xml/world_config.xml').read }
  let(:building_info) { File.new('spec/fixtures/xml/building_info.xml').read }
  let(:unit_info) { File.new('spec/fixtures/xml/unit_info.xml').read }

  before do
    begin
      allow(client).to receive(:world_list).and_return(
        { 'en107' => 'https://en107.tribalwars.net',
          'en110' => 'https://en110.tribalwars.net',
          'en111' => 'https://en111.tribalwars.net',
          'en112' => 'https://en112.tribalwars.net',
          'en113' => 'https://en113.tribalwars.net',
          'enp8' => 'https://enp8.tribalwars.net' }
      )
    rescue ArgumentError
      'This is just to suppress error when trying to stub client with invalid options'
    end
    @servers_stub = stub_request(:get, 'https://www.tribalwars.net/backend/get_servers.php').to_return(
      status: 200,
      body: 'a:12:{s:5:"en107";s:28:"https://en107.tribalwars.net";s:5:"en110";s:28:"https://en110.tribalwars.net";s:5:"en111";s:28:"https://en111.tribalwars.net";s:5:"en112";s:28:"https://en112.tribalwars.net";s:5:"en113";s:28:"https://en113.tribalwars.net";s:4:"enp8";s:27:"https://enp8.tribalwars.net";}',
      headers: {}
    )

    @player_stub = stub_request(:get, 'https://en110.tribalwars.net/map/player.txt').to_return(
      status: 200,
      body: players
    )
    @village_stub = stub_request(:get, 'https://en110.tribalwars.net/map/village.txt').to_return(
      status: 200,
      body: villages
    )
    @ally_stub = stub_request(:get, 'https://en110.tribalwars.net/map/ally.txt').to_return(
      status: 200,
      body: tribes
    )
    @config_stub = stub_request(:get, 'https://en110.tribalwars.net/interface.php?func=get_config').to_return(
      status: 200,
      body: world_config
    )
    @building_info_stub = stub_request(:get, 'https://en110.tribalwars.net/interface.php?func=get_building_info').to_return(
      status: 200,
      body: building_info
    )
    @unit_info_stub = stub_request(:get, 'https://en110.tribalwars.net/interface.php?func=get_unit_info').to_return(
      status: 200,
      body: unit_info
    )
  end
end
