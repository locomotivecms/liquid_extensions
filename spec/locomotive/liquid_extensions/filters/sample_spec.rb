require 'spec_helper'

describe Locomotive::LiquidExtensions::Filters::Sample do

  include Locomotive::LiquidExtensions::Filters::Sample

  it 'returns random element of an array' do
    array = ["Foo", "Bar", "Locomotive"]
    sample(array).should be_a String
    array.should include(sample(array, 1))
  end

  it 'return the number of random elements of an array' do
    array = ["Foo", "Bar", "Locomotive"]
    smpl = sample(array, 2)
    smpl.size.should eql 2
    smpl.first.should_not eql smpl.last
    array.should include(smpl.first)
    array.should include(smpl.last)
  end

end