require 'spec_helper'

describe Locomotive::LiquidExtensions::Filters::Json do

  include Locomotive::LiquidExtensions::Filters::Json

  let(:input) { nil }
  subject     { json(*input) }

  describe 'adds quotes to a string' do

    let(:input) { 'foo' }
    it { should eq %("foo") }

  end

  context 'drop' do

    describe 'includes only the fields specified' do

      let(:input) { [CustomModel.new(title: 'Acme', body: 'Lorem ipsum'), 'title'] }
      it { should eq %("title":"Acme") }

    end

  end

  context 'collections' do

    describe 'adds brackets and quotes to a collection' do

      let(:input) { [['foo', 'bar']] }
      it { should eq %(["foo","bar"]) }

    end

    describe 'includes the first field' do

      let(:input) {
        [[CustomModel.new(title: 'Acme', body: 'Lorem ipsum'),
          CustomModel.new(title: 'Hello world', body: 'Lorem ipsum')], 'title'] }
      it { should eq %("Acme","Hello world") }

    end

    describe 'includes the specified fields' do

      let(:input) {
        [[CustomModel.new(title: 'Acme', body: 'Lorem ipsum', date: '2013-12-13'),
          CustomModel.new(title: 'Hello world', body: 'Lorem ipsum', date: '2013-12-12')], 'title, body'] }
      it { should eq %({"title":"Acme","body":"Lorem ipsum"},{"title":"Hello world","body":"Lorem ipsum"}) }

    end

  end

end
