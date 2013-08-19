require 'spec_helper'

describe Locomotive::LiquidExtensions::Tags::Update do

  let(:tag_class) { Locomotive::LiquidExtensions::Tags::Update }

  describe '#display' do

    let(:model) { CustomModel.new(title: 'Locomotive') }
    let(:tokens) { ['{{ project.title }}', ' has been updated', '{% else %}', 'Failed', '{% endupdate %}', 'outside'] }
    let(:options) { "project, title: 'LocomotiveCMS'" }
    let(:assigns) { { 'project' => model, 'wagon' => false } }
    let(:context) { Liquid::Context.new({}, assigns, { logger: CustomLogger }) }

    subject { tag_class.new('update', options, tokens) }

    it 'displays the success message if the model was persisted' do
      model.expects(:save).returns(true)
      subject.render(context).should be == 'LocomotiveCMS has been updated'
    end

    it 'displays the fail message if the model was NOT persisted' do
      model.expects(:save).returns(false)
      subject.render(context).should be == 'Failed'
    end

    describe 'no model' do

      let(:model) { nil }

      it 'displays the fail message' do
        subject.render(context).should be == 'Failed'
      end

    end

    describe 'invalid syntax' do

      subject { lambda { tag_class.new('update', options, tokens).render(context) } }

      describe 'no model' do

        let(:options) { '' }
        it { should raise_exception('[update] wrong number of parameters (2 are required)') }

      end

      describe 'no attributes' do

        let(:options) { 'project' }
        it { should raise_exception('[update] wrong number of parameters (2 are required)') }

      end

      describe 'incorrect attributes' do

        let(:options) { "project, 'foo'" }
        it { should raise_exception('[update] wrong attributes') }

      end

    end

    context 'in Wagon' do

      let(:assigns) { { 'project' => model, 'wagon' => true } }

      it 'displays the success message if the model was persisted' do
        model.expects(:valid?).returns(true)
        subject.render(context).should be == 'LocomotiveCMS has been updated'
      end

      it 'displays the fail message if the model was NOT persisted' do
        model.expects(:valid?).returns(false)
        subject.render(context).should be == 'Failed'
      end

    end

  end
end
