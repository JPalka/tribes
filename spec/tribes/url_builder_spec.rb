# frozen_string_literal: true

RSpec.describe Tribes::URLBuilder do
  describe '#initialize' do
    it 'creates URLBuilder object' do
      expect(subject).to be_a(Tribes::URLBuilder)
    end
  end

  context 'create simple url' do
    subject { Tribes::URLBuilder.new.https.host('example.com').url }
    it { expect(subject).to eq('https://example.com') }

    context 'with protocol missing' do
      subject { Tribes::URLBuilder.new.host('example.com').url }

      it { expect { subject }.to raise_error(RuntimeError, "protocol can't be null") }
    end

    context 'with host missing' do
      subject { Tribes::URLBuilder.new.https.url }

      it { expect { subject }.to raise_error(RuntimeError, "host can't be null") }
    end
  end

  context 'create api service url' do
    let(:builder) do
      Tribes::URLBuilder.new
                        .https
                        .host('example.com')
                        .master_server_api
                        .service('login')
    end
    context 'with one param' do
      subject { builder.add_query_param('hash', '6asd89ast87290398ausd9820').url }
      it { expect(subject).to eq('https://example.com/m/m/login?hash=6asd89ast87290398ausd9820') }
    end

    context 'with no params' do
      subject { builder.url }
      it { expect(subject).to eq('https://example.com/m/m/login') }
    end

    context 'with multiple params' do
      subject { builder.add_query_param('param1', 'value2').add_query_param('param2', 'value2').url }

      it { expect(subject).to eq('https://example.com/m/m/login?param1=value2&param2=value2') }
    end
  end
end
