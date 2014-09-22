require 'spec_helper'

describe Locomotive::LiquidExtensions::Tags::For do

  before { ::Liquid::Template.error_mode = :strict }

  let(:tag_class) { Locomotive::LiquidExtensions::Tags::For }

  let(:array) { [] }
  let(:tokens) { ['{{ item }}', '{% endfor %}', 'outside'] }
  let(:options) { "item in my_array" }
  let(:assigns) { { 'my_array' => array } }
  let(:context) { Liquid::Context.new({}, assigns, { logger: CustomLogger }) }

  subject { tag_class.new('for', options, tokens, {}).render(context) }

  describe 'an empty array' do

    it { should be == '' }

  end

  describe 'a non-empty array' do

    let(:array) { [42, 'Acme', 'Hello world'] }

    it { should be == '42AcmeHello world' }

    describe 'join option' do

      let(:options) { "item in my_array join: ', '" }

      it { should be == '42, Acme, Hello world' }

      describe 'with a blank item' do

        let(:array) { [42, 'Acme', nil, 'Hello world', '', "\n"] }

        it { should be == '42, Acme, Hello world' }

      end

    end

  end

end
