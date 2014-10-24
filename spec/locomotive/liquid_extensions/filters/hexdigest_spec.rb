require 'spec_helper'

describe Locomotive::LiquidExtensions::Filters::Hexdigest do

  include Locomotive::LiquidExtensions::Filters::Hexdigest

  let(:key)     { 'key' }
  let(:data)    { 'The quick brown fox jumps over the lazy dog' }
  let(:digest)  { nil }

  subject { hexdigest(data, key, digest) }

  it 'returns the authentication code as a hex-encoded string' do
    expect(subject).to eq 'de7c9b85b8b78aa6bc8a7a36f70a90701c9db4d9'
  end

end
