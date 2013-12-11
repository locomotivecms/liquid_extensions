require 'spec_helper'

describe Locomotive::LiquidExtensions::Filters::Json do

  include Locomotive::LiquidExtensions::Filters::Json

  describe '#json' do

    it 'adds quotes to a string' do
      json('foo').should == %("foo")
    end

    context 'drop' do

      it 'includes only the fields specified' do
        json(CustomModel.new(title: 'Acme', body: 'Lorem ipsum'), 'title').should == %("title":"Acme")
      end

    end

    context 'collections' do

      it 'adds brackets and quotes to a collection' do
        json(['foo', 'bar']).should == %(["foo","bar"])
      end

      it 'includes the first field' do
        json([
          CustomModel.new(title: 'Acme', body: 'Lorem ipsum'),
          CustomModel.new(title: 'Hello world', body: 'Lorem ipsum')
        ], 'title').should == %("Acme","Hello world")
      end

      it 'includes the specified fields' do
        json([
          CustomModel.new(title: 'Acme', body: 'Lorem ipsum', date: '2013-12-13'),
          CustomModel.new(title: 'Hello world', body: 'Lorem ipsum', date: '2013-12-12')
        ], 'title, body').should == %({"title":"Acme","body":"Lorem ipsum"},{"title":"Hello world","body":"Lorem ipsum"})
      end

    end

  end

end
