# frozen_string_literal: true

require 'support/shared_contexts/client_class'

RSpec.describe Tribes::Client do
  include_context 'client class'

  describe '#initialize' do
    let(:expected_attributes) do
      {
        login: 'korenchkin',
        password: 'rickenbacker1',
        master_server: 'https://www.tribalwars.net'
      }
    end
    subject { client }

    context 'with no parameter' do
      it { expect { subject }.not_to raise_error }
      it { expect(subject.configuration).to have_attributes(expected_attributes) }
    end

    context 'with parameter given' do
      context 'valid url' do
        let(:options) { { master_server: 'https://plemiona.pl' } }

        it { expect { subject }.not_to raise_error }
        it { expect(subject.configuration).to have_attributes(options) }
      end

      context 'invalid url' do
        let(:options) { { master_server: 'https:::///\/\/invalid.url..' } }

        it { expect { subject }.to raise_error(ArgumentError, 'Argument is not a valid URL') }
      end
    end
  end
end
