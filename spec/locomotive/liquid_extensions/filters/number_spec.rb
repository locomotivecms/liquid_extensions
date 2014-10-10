# encoding: utf-8

require 'spec_helper'

describe Locomotive::LiquidExtensions::Filters::Number do

  include Locomotive::LiquidExtensions::Filters::Number

  let(:environments)  { {} }
  let(:input)         { nil }
  let(:options)       { nil }

  before { @context = Liquid::Context.new(environments) }

  it 'should not invoke directly the number_to_xxx methods' do
    respond_to?(:number_to_currency).should eq false
  end

  describe '#money' do

    subject { money(input, options) }

    context 'not a number' do

      it { should eq nil }

    end

    context 'a number' do

      let(:input) { 42.01 }

      it { should eq '$42.01' }

    end

    context 'with options' do

      let(:input) { 42.01 }
      let(:options) { ['unit: "€"', 'format: "%n %u"', 'precision: 1'] }

      it { should eq '42.0 €' }

    end

    context "one of the options is a liquid variable" do

      let(:environments)  { { 'my_unit' => 'Franc' } }

      let(:input) { 42.01 }
      let(:options) { ['unit: my_unit', 'format: "%n %u"'] }

      it { should eq '42.01 Franc' }

    end

  end

  describe '#percentage' do

    subject { percentage(input, options) }

    context 'not a number' do

      it { should eq nil }

    end

    context 'a number' do

      let(:input) { 42.01 }

      it { should eq '42.010%' }

    end

    context 'with options' do

      let(:input) { '42.01' }
      let(:options) { ['precision: 0'] }

      it { should eq '42%' }

    end

  end

end
