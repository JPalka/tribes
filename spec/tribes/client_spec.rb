# frozen_string_literal: true

RSpec.describe Tribes::Client do
  describe '#initialize' do
    subject { described_class.new }
    context 'with no parameter' do
      let(:expected_default) { 'https://tribalwars.net' }
      it { expect { subject }.not_to raise_error }
      it { expect(subject).to have_attributes(base_link: expected_default) }
    end

    context 'with parameter given' do
      subject { described_class.new(url) }

      context 'valid url' do
        let(:url) { 'https://plemiona.pl' }

        it { expect { subject }.not_to raise_error }
        it { expect(subject).to have_attributes(base_link: url) }
      end

      context 'invalid url' do
        let(:url) { 'https:::///\/\/invalid.url..' }

        it { expect { subject }.to raise_error(ArgumentError) }
      end
    end
  end

  describe '#world=' do
    let(:client) { described_class.new }
    before do
      allow(client).to receive(:world_list).and_return(
        { 'en107' => 'https://en107.tribalwars.net',
          'en110' => 'https://en110.tribalwars.net',
          'en111' => 'https://en111.tribalwars.net',
          'en112' => 'https://en112.tribalwars.net',
          'en113' => 'https://en113.tribalwars.net',
          'enp8' => 'https://enp8.tribalwars.net' }
      )
    end

    context 'when world exist on the server' do
      subject { client.world = 'en110' }
      it { expect { subject }.not_to raise_error }
      it { expect { subject }.to change { client.world }.to 'en110' }
    end

    context 'when world does not exist on the server' do
      subject { client.world = 'yoloworld' }

      let(:error_msg) { 'World not found: yoloworld' }

      it { expect { subject }.to raise_error(ArgumentError, error_msg) }
    end
  end

  describe '#world_list' do
    subject { described_class.new.world_list }

    before do
      @stub = stub_request(:get, 'https://tribalwars.net/backend/get_servers.php').to_return(
        status: 200,
        body: 'a:12:{s:5:"en107";s:28:"https://en107.tribalwars.net";s:5:"en110";s:28:"https://en110.tribalwars.net";s:5:"en111";s:28:"https://en111.tribalwars.net";s:5:"en112";s:28:"https://en112.tribalwars.net";s:5:"en113";s:28:"https://en113.tribalwars.net";s:4:"enp8";s:27:"https://enp8.tribalwars.net";}',
        headers: {}
      )
    end

    context 'when remote server exists' do
      let(:expected_result) do
        { 'en107' => 'https://en107.tribalwars.net',
          'en110' => 'https://en110.tribalwars.net',
          'en111' => 'https://en111.tribalwars.net',
          'en112' => 'https://en112.tribalwars.net',
          'en113' => 'https://en113.tribalwars.net',
          'enp8' => 'https://enp8.tribalwars.net' }
      end
      it { expect(subject).to be_a(Hash) }
      it { expect(subject).to eq(expected_result) }
      it 'is memoized' do
        2.times { subject }
        expect(@stub).to have_been_requested.times(1)
        expect(subject).to eq(expected_result)
      end
    end

    context 'remote does not exist' do
      before do
        @stub = stub_request(:get, 'http://nositesherlock/backend/get_servers.php').to_return(
          status: 404
        )
      end
      subject { described_class.new('http://nositesherlock').world_list }

      it { expect(subject).to be_a(Hash) }
      it { expect(subject).to eq({}) }
    end
  end

  describe '#player_list' do
    let(:client) { described_class.new }
    let(:players) do
      "898,piratedan,1023,1,1347,1644\n"\
      "7297,darkx,85,3,6594,88\n"\
      "10083,zora+ostar,1060,1,916,2569\n"\
      "15035,DrakenZ,328,1,506,4317\n"\
      "17977,Tyrungal,104,1,1158,1961\n"\
      "24949,FeudalKnight,0,1,242,6836"
    end
    before do
      allow(client).to receive(:world_list).and_return(
        { 'en107' => 'https://en107.tribalwars.net',
          'en110' => 'https://en110.tribalwars.net',
          'en111' => 'https://en111.tribalwars.net',
          'en112' => 'https://en112.tribalwars.net',
          'en113' => 'https://en113.tribalwars.net',
          'enp8' => 'https://enp8.tribalwars.net' }
      )
      @stub = stub_request(:get, 'https://en110.tribalwars.net/map/player.txt').to_return(
        status: 200,
        body: players
      )
      client.world = 'en110'
    end
    subject { client.player_list }

    it do
      expect(subject).to eq [
        { id: 898, name: 'piratedan', tribe_id: 1023, village_count: 1, points: 1347, rank: 1644 },
        { id: 7297, name: 'darkx', tribe_id: 85, village_count: 3, points: 6594, rank: 88 },
        { id: 10_083, name: 'zora+ostar', tribe_id: 1060, village_count: 1, points: 916, rank: 2569 },
        { id: 15_035, name: 'DrakenZ', tribe_id: 328, village_count: 1, points: 506, rank: 4317 },
        { id: 17_977, name: 'Tyrungal', tribe_id: 104, village_count: 1, points: 1158, rank: 1961 },
        { id: 24_949, name: 'FeudalKnight', tribe_id: 0, village_count: 1, points: 242, rank: 6836 }
      ]
    end
  end

  describe '#village_list' do
    let(:client) { described_class.new }
    let(:villages) do
      "1,%2B+KINGS+CASTLE+%2B,500,476,267865,1533,0\n"\
      "2,001,502,472,9828389,3170,0\n"\
      "3,335D,507,482,11295245,2388,0\n"
    end
    before do
      allow(client).to receive(:world_list).and_return(
        { 'en107' => 'https://en107.tribalwars.net',
          'en110' => 'https://en110.tribalwars.net',
          'en111' => 'https://en111.tribalwars.net',
          'en112' => 'https://en112.tribalwars.net',
          'en113' => 'https://en113.tribalwars.net',
          'enp8' => 'https://enp8.tribalwars.net' }
      )
      @stub = stub_request(:get, 'https://en110.tribalwars.net/map/village.txt').to_return(
        status: 200,
        body: villages
      )
      client.world = 'en110'
    end
    subject { client.village_list }
    it do
      expect(subject).to eq [
        { id: 1, name: '%2B+KINGS+CASTLE+%2B', x: 500, y: 476, player_id: 267_865, points: 1533, rank: 0 },
        { id: 2, name: '001', x: 502, y: 472, player_id: 9_828_389, points: 3170, rank: 0 },
        { id: 3, name: '335D', x: 507, y: 482, player_id: 11_295_245, points: 2388, rank: 0 }
      ]
    end
  end

  describe '#tribe_list' do
    let(:client) { described_class.new }
    let(:tribes) do
      "2,Zini,Zanzo,1,1,486,486,169\n"\
      "7,Lions+of+the+Night,Lions,3,3,4571,4571,111\n"\
      "9,Cerberus,Hades,11,32,147555,147555,31\n"
    end
    before do
      allow(client).to receive(:world_list).and_return(
        { 'en107' => 'https://en107.tribalwars.net',
          'en110' => 'https://en110.tribalwars.net',
          'en111' => 'https://en111.tribalwars.net',
          'en112' => 'https://en112.tribalwars.net',
          'en113' => 'https://en113.tribalwars.net',
          'enp8' => 'https://enp8.tribalwars.net' }
      )
      @stub = stub_request(:get, 'https://en110.tribalwars.net/map/ally.txt').to_return(
        status: 200,
        body: tribes
      )
      client.world = 'en110'
    end
    subject { client.tribe_list }

    it do
      expect(subject).to eq [
        { id: 2, name: 'Zini', tag: 'Zanzo', member_count: 1, village_count: 1,
          points_top: 486, points: 486, rank: 169 },
        { id: 7, name: 'Lions+of+the+Night', tag: 'Lions', member_count: 3, village_count: 3,
          points_top: 4571, points: 4571, rank: 111 },
        { id: 9, name: 'Cerberus', tag: 'Hades', member_count: 11, village_count: 32,
          points_top: 147_555, points: 147_555, rank: 31 }
      ]
    end
  end

  describe '#world_config' do
    let(:client) { described_class.new }
    let(:config) { File.new('spec/fixtures/xml/world_config.xml').read }
    before do
      allow(client).to receive(:world_list).and_return(
        { 'en107' => 'https://en107.tribalwars.net',
          'en110' => 'https://en110.tribalwars.net' }
      )
      @stub = stub_request(:get, 'https://en110.tribalwars.net/interface.php?func=get_config').to_return(
        status: 200,
        body: config
      )
      client.world = 'en110'
    end
    subject { client.world_config }

    it { expect(subject).to be_a(Hash) }
    it { expect(subject).not_to be_empty }
  end

  describe '#building_info' do
    let(:client) { described_class.new }
    let(:info) { File.new('spec/fixtures/xml/building_info.xml').read }
    before do
      allow(client).to receive(:world_list).and_return(
        { 'en107' => 'https://en107.tribalwars.net',
          'en110' => 'https://en110.tribalwars.net' }
      )
      @stub = stub_request(:get, 'https://en110.tribalwars.net/interface.php?func=get_building_info').to_return(
        status: 200,
        body: info
      )
      client.world = 'en110'
    end
    subject { client.building_info }

    it { expect(subject).to be_a(Hash) }
    it { expect(subject).not_to be_empty }
  end
end
