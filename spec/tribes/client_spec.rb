# frozen_string_literal: true

require 'support/shared_contexts/client_class'

RSpec.describe Tribes::Client do
  include_context 'client class'

  describe '#initialize' do
    let(:expected_attributes) do
      {
        login: 'korenchkin',
        password: 'rickenbacker1',
        remote_host: 'https://www.tribalwars.net'
      }
    end
    subject { client }

    context 'with no parameter' do
      it { expect { subject }.not_to raise_error }
      it { expect(subject.configuration).to have_attributes(expected_attributes) }
    end

    context 'with parameter given' do
      context 'valid url' do
        let(:options) { { remote_host: 'https://plemiona.pl' } }

        it { expect { subject }.not_to raise_error }
        it { expect(subject.configuration).to have_attributes(options) }
      end

      context 'invalid url' do
        let(:options) { { remote_host: 'https:::///\/\/invalid.url..' } }

        it { expect { subject }.to raise_error(ArgumentError, 'Argument is not a valid URL') }
      end
    end
  end

  describe '#world=' do
    context 'when world exist on the server' do
      subject { client.world = 'en110' }
      it { expect { subject }.not_to raise_error }
      it { expect { subject }.to change { client.configuration.current_world }.to 'en110' }
    end

    context 'when world does not exist on the server' do
      subject { client.world = 'yoloworld' }

      let(:error_msg) { 'World not found: yoloworld' }

      it { expect { subject }.to raise_error(ArgumentError, error_msg) }
    end
  end

  describe '#player_list' do
    before do
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
    before do
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
    before do
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
    before do
      client.world = 'en110'
    end
    subject { client.world_config }

    it { expect(subject).to be_a(Hash) }
    it { expect(subject).not_to be_empty }
  end

  describe '#building_info' do
    before do
      client.world = 'en110'
    end
    subject { client.building_info }

    it { expect(subject).to be_a(Hash) }
    it { expect(subject).not_to be_empty }
  end

  describe '#unit_info' do
    before do
      client.world = 'en110'
    end
    subject { client.unit_info }

    it { expect(subject).to be_a(Hash) }
    it { expect(subject).not_to be_empty }
  end
end
