RSpec.describe Tribes::Client::Configuration do
  let(:config) { described_class.new }
  let(:default_params) do
    { login: 'login', password: 'password', remote_host: 'https://www.tribalwars.net' }
  end
  before do
    @stub = stub_request(:get, 'https://www.tribalwars.net/backend/get_servers.php').to_return(
      status: 200,
      body: 'a:12:{s:5:"en107";s:28:"https://en107.tribalwars.net";s:5:"en110";s:28:"https://en110.tribalwars.net";s:5:"en111";s:28:"https://en111.tribalwars.net";s:5:"en112";s:28:"https://en112.tribalwars.net";s:5:"en113";s:28:"https://en113.tribalwars.net";s:4:"enp8";s:27:"https://enp8.tribalwars.net";}',
      headers: {}
    )
  end

  it { is_expected.to have_attributes(default_params) }

  describe '#current_world=' do
    subject { config.current_world = 'en110' }
    it 'is private' do
      expect { subject }.to raise_error(NoMethodError)
    end
  end
  
  describe '#merge' do
    subject { config.merge(options) }

    context 'with proper options' do
      let(:options) { { remote_host: 'http://host.pl', login: 'korenchkin', password: 'rickenbacker' } }

      it { expect { subject }.to change { config.remote_host }.to('http://host.pl') }
      it { expect { subject }.to change { config.login }.to('korenchkin') }
      it { expect { subject }.to change { config.password }.to('rickenbacker') }
    end

    context 'with invalid options' do
      let(:options) { { remote: 'http://herpaderp', jazz: 1000, afhljhjafjk: 'kldaslk' } }

      it do
        expect { subject }.to raise_error(ArgumentError,
                                          'Invalid options: remote, jazz, afhljhjafjk')
      end
    end
  end

  describe '#remote_host=' do
    context 'when host is valid' do
      subject { config.remote_host = 'https://www.plemiona.pl' }

      it { expect { subject }.to change { config.remote_host }.to 'https://www.plemiona.pl' }
    end

    context 'when host is invalid' do
      subject { config.remote_host = 'https:\/\/\/.....invalidurl?aSdas' }

      it { expect { subject }.to raise_error(ArgumentError, 'Argument is not a valid URL') }
    end
  end

  describe '#world_list' do
    subject { config.world_list }

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
      subject { config.merge(remote_host: 'http://nositesherlock').world_list }

      it { expect(subject).to be_a(Hash) }
      it { expect(subject).to eq({}) }
    end
  end
end
