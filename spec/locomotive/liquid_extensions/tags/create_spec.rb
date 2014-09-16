require 'spec_helper'

describe Locomotive::LiquidExtensions::Tags::Create do

  let(:tag_class) { Locomotive::LiquidExtensions::Tags::Create }

  describe '#display' do

    let(:markup)    { "'projects', title: 'LocomotiveCMS'" }
    let(:tokens)    { ['{{ project.title }}', ' has been created', '{% else %}', 'Failed - ', '{{project.errors.first.first }}', ' ', '{{project.errors.first.last }}', '{% endcreate %}', 'outside'] }
    # let(:options)   { { locale: Liquid::I18n.new } }
    let(:options)   { {} }
    let(:assigns)   { { 'wagon' => false } }
    let(:registers) { {} }
    let(:context)   { Liquid::Context.new({}, assigns, { logger: CustomLogger }.merge(registers)) }

    subject { tag_class.new('create', markup, tokens, options) }

    describe 'invalid syntax' do

      subject { lambda { tag_class.new('create', markup, tokens, options).render(context) } }

      describe 'no model name' do

        let(:markup) { '' }
        it { should raise_exception('[create] wrong number of parameters (2 are required)') }

      end

      describe 'no attributes' do

        let(:markup) { 'projects' }
        it { should raise_exception('[create] wrong number of parameters (2 are required)') }

      end

      describe 'incorrect attributes' do

        let(:markup) { "projects, 'foo'" }
        it { should raise_exception('[create] wrong attributes') }

      end

    end

    describe 'displaying it' do

      let(:source)        { nil }
      let(:content_type)  { build_content_type(source, 'projects') }
      let(:model)         { build_model(content_type, title: 'LocomotiveCMS') }
      let(:registers)     { { site: source, mounting_point: source } }

      context 'in the engine' do

        let(:source) { stub(content_types: stub, wagon: false) }

        it 'displays the success message if the model was persisted' do
          model.expects(:save).returns(true)
          subject.render(context).should be == 'LocomotiveCMS has been created'
        end

        it 'displays the fail message if the model was NOT persisted' do
          model.expects(:save).returns(false)
          model.expects(:errors).twice.returns(stub(messages: { title: ['is missing'] }))
          subject.render(context).should be == 'Failed - title is missing'
        end

      end

      context 'in Wagon' do

        let(:source)  { stub(content_types: stub, wagon: true) }
        let(:assigns) { { 'wagon' => true } }

        it 'displays the success message if the model was persisted' do
          model.expects(:valid?).returns(true)
          subject.render(context).should be == 'LocomotiveCMS has been created'
        end

        it 'displays the fail message if the model was NOT persisted' do
          model.expects(:valid?).returns(false)
          model.expects(:errors).twice.returns(stub(messages: { title: ['is missing'] }))
          subject.render(context).should be == 'Failed - title is missing'
        end

      end

    end

  end

  def build_content_type(site_or_mounting_point, model_name)
    return if site_or_mounting_point.nil?

    if site_or_mounting_point.wagon
      stub(build_entry: nil, wagon: true).tap do |content_type|
        site_or_mounting_point.expects(:content_types).returns(model_name => content_type)
      end
    else
      stub(entries: [], wagon: false).tap do |content_type|
        site_or_mounting_point.content_types.expects(:where).with(slug: model_name).returns([content_type])
      end
    end
  end

  def build_model(content_type, attributes = {})
    CustomModel.new(attributes).tap do |model|
      if content_type.wagon
        content_type.expects(:build_entry).with(attributes).returns(model)
      else
        content_type.entries.expects(:build).with(attributes).returns(model)
      end
    end
  end
end
