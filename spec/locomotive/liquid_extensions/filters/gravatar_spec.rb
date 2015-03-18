require 'spec_helper'

describe Locomotive::LiquidExtensions::Filters::Gravatar do

  include Locomotive::LiquidExtensions::Filters::Gravatar

  it 'generates a correct url' do
    email    = 'me@example.com'
    expected = 'http://www.gravatar.com/avatar/2e0d5407ce8609047b8255c50405d7b1'
    actual   = gravatar_url(email)
    actual.should be_a String
    actual.should eql expected
  end

  it 'generates a proper img tag' do
    email = 'me@example.com'
    tag   = gravatar_tag(email)
    tag.should be_a String
    tag.should start_with '<img '
    tag.should end_with '/>'
    tag.should include 'src="http://www.gravatar.com/avatar/2e0d5407ce8609047b8255c50405d7b1"'
  end

  it 'escapes characters in an img tag' do
    email = 'me@example.com'
    tag   = gravatar_tag(email, 's:200', 'd:mm')
    tag.should be_a String
    tag.should include '&amp;'
  end

end
