# frozen_string_literal: true

RSpec.describe Tribes::Headers do
  let(:headers) { described_class.new }
  let(:header) { 'test header' }
  let(:value) { 'test value' }
  let(:header2) { 'tst header2' }
  let(:value2) { 'test value2' }

  describe '#initialize' do
    it 'has default headers set' do
      expect(subject.to_h).to eq(
        {
          # 'Accept-Encoding' => 'deflate, gzip',
          'User-Agent' => 'Mozilla/5.0 (Android; U; pl-PL) AppleWebKit/533.19.4 (KHTML,like Gecko) AdobeAIR/31.0',
          'x-flash-version' => '31,0,0,101',
          'Connection' => 'Keep-Alive',
          'Cache-Control' => 'no-cache',
          'Referer' => 'app:/staemme.swf',
          'Content-Type' => 'flv-application/octet-stream; charset=UTF-8',
          'x-ig-os-name' => 'android',
          'x-ig-os-version' => '5.0',
          'x-ig-model' => 'HTC One',
          'x-ig-manufacturer' => 'HTC',
          'IGMobileDevice' => 'Android'
        }
      )
    end
  end

  describe '#set' do
    subject do
      headers.set(header, value)
      headers.set(header2, value2)
    end

    it { expect(subject.to_h).to include(header => value) }
    it { expect(subject.to_h).to include(header2 => value2) }
  end

  describe '#remove' do
    before { headers.set(header, value) }
    subject { headers.remove(header) }

    it { expect { subject }.to change { headers.to_h.key?(header) }.to(false) }
  end
end
