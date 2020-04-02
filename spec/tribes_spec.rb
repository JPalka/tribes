# frozen_string_literal: true

RSpec.describe Tribes do
  it 'has a version number' do
    expect(Tribes::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end

  it 'test webmock external request blocking' do
    uri = URI('https://api.github.com/repos/thoughtbot/factory_girl/contributors')

    expect { Net::HTTP.get(uri) }.to raise_error(WebMock::NetConnectNotAllowedError)
  end
end
