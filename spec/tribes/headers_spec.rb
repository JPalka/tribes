
RSpec.describe Tribes::Headers do
  let(:headers) { described_class.new }
  let(:header) { 'Accept-Encoding' }
  let(:value) { 'deflate, gzip' }
  let(:header2) { 'Connection' }
  let(:value2) { 'Keep-Alive' }
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
