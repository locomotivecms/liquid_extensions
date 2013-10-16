require 'spec_helper'

describe Locomotive::LiquidExtensions::Filters::Sample do

  include Locomotive::LiquidExtensions::Filters::Sample

  it 'return a sample of an array' do
    array = ["Foo", "Bar", "Locomotive"]
    (array - sample(array, 1)).size.should eql 2
  end


end