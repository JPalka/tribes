# frozen_string_literal: true

RSpec.describe Tribes::Client::Configuration do
  let(:config) { described_class.new }
  let(:default_params) do
    { login: 'korenchkin', password: 'rickenbacker1', master_server: 'https://www.tribalwars.net' }
  end
  it { is_expected.to have_attributes(default_params) }

  describe '#merge' do
    subject { config.merge(options) }

    context 'with proper options' do
      let(:options) { { master_server: 'http://host.pl', login: 'newlogin', password: 'rickenbacker' } }

      it { expect { subject }.to change { config.master_server }.to('http://host.pl') }
      it { expect { subject }.to change { config.login }.to('newlogin') }
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
end
