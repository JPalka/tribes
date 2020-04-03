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
end
