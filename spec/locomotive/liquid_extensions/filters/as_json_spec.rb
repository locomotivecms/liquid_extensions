require 'spec_helper'

describe Locomotive::LiquidExtensions::Filters::ParseJson do

  include Locomotive::LiquidExtensions::Filters::ParseJson

  let(:input) { nil }
  subject     { as_json(*input) }

  describe 'parse string' do

    let(:input) { '{"foo":"bar"}' }
    it { should eq({"foo" => "bar"}) }

  end

  describe 'fail with message' do

    let(:input) { '' }
    it { should eq("JSON has wrong format") }

  end

end
