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

end
