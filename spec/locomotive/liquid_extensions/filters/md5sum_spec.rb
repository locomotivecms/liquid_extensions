require 'spec_helper'

describe Locomotive::LiquidExtensions::Filters::Md5sum do

  include Locomotive::LiquidExtensions::Filters::Md5sum

  it 'calculates the md5sum of a string' do
    original = 'The quick brown fox jumps over the lazy dog'
    expected = '9e107d9d372bb6826bd81d3542a419d6'
    actual   = md5sum(original)
    actual.should be_a String
    actual.should eql expected
  end

end
