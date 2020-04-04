# frozen_string_literal: true

RSpec.describe Tribes do
  it 'has a version number' do
    expect(Tribes::VERSION).not_to be nil
  end

  it 'test webmock external request blocking' do
    uri = URI('https://api.github.com/repos/thoughtbot/factory_girl/contributors')

    expect { Net::HTTP.get(uri) }.to raise_error(WebMock::NetConnectNotAllowedError)
  end

  describe '.calculate_mobile_hash' do
    subject { Tribes.calculate_mobile_hash(data) }

    context 'for login data array' do
      let(:data) { ['korenchkin', 'rickenbacker1', '2.30.0'] }

      it { expect(subject).to eq 'bf774c157a1724b38f8c01d2c7d12e8081821ecc' }
    end

    context 'for array with one element' do
      let(:data) { ["5682439b4ec15f78a9b2d4d409bfb37e7d840a82"] }

      it { expect(subject).to eq '8303726eafff094edec319dffdf1774973aa0880' }
    end

    context 'for single element' do
      let(:data) { "5682439b4ec15f78a9b2d4d409bfb37e7d840a82" }

      it { expect { subject }.to raise_error(ArgumentError, 'Method accepts only arrays') }
    end

    context 'for hash' do
      let(:data) { { prop1: 'korenchkin', prop2: 'rickenbacker1', prop3: '2.30.0' } }

      it { expect { subject }.to raise_error(ArgumentError, 'Method accepts only arrays') }
    end
  end
end
