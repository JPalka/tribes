# frozen_string_literal: true

RSpec.describe Tribes::Client do
  describe '#initialize' do
    subject { described_class.new }
    context 'with no parameter' do
      let(:expected_default) { 'https://tribalwars.net' }
      it { expect { subject }.not_to raise_error }
      it { expect(subject.base_link).to eq expected_default }
    end

    context 'with parameter given' do
      subject { described_class.new(url) }

      context 'valid url' do
        let(:url) { 'https://plemiona.pl' }

        it { expect { subject }.not_to raise_error }
        it { expect(subject.base_link).to eq url }
      end

      context 'invalid url' do
        let(:url) { 'https:::///\/\/invalid.url..' }

        it { expect { subject }.to raise_error(ArgumentError) }
      end
    end
  end
end
