require 'spec_helper'

describe Locomotive::LiquidExtensions::Tags::Cacher do

  let(:tag_class)   { Locomotive::LiquidExtensions::Tags::Cacher }
  let(:key_prefix)  { tag_class::CACHE_KEY_ROOT_NAMESPACE }
  let(:arguments)   { "'test-key'" }
  let(:markup)      { "" }
  let(:tokens)      { [markup, '{% endcache %}', 'outside'] }
  let(:assigns)     { {} }
  let(:environment) { {} }
  let(:context)     { Liquid::Context.new(environment, assigns, { logger: CustomLogger }) }

  let(:tag) { tag_class.new('cache', arguments, tokens, {}) }
  subject   { tag.render(context) }

  describe "baseline markup" do
    it "should be a string" do
      expect(subject).to be_a String
    end

    it "should be a blank string" do
      expect(subject).to eq ''
    end
  end

  context "when contains markup" do
    let(:markup) { "<div>This is a cache fragment</div>" }
    it "should return what it's given" do
      expect(subject).to eq markup
    end
  end

  context "nil key" do
    let(:arguments) { nil }
    it "should raise an error" do
      expect { subject }.to raise_error Locomotive::LiquidExtensions::Tags::Cacher::ERROR_CACHE_KEY_REQUIRED
    end
  end

  context "blank key" do
    let(:arguments) { "" }
    it "should raise an error" do
      expect { subject }.to raise_error Locomotive::LiquidExtensions::Tags::Cacher::ERROR_CACHE_KEY_REQUIRED
    end
  end

  context "cache key" do
    before(:each) do
      # force render
      subject
    end

    context "separators" do
      context "key with dash" do
        let(:arguments) { "'test-key'" }
        it "should use the given key since it's valid" do
          expect(tag.key).to eq testkey("test-key")
        end
      end

      context "key with underscore" do
        let(:arguments) { "'test_key'" }
        it "should use the given key since it's valid" do
          expect(tag.key).to eq testkey("test_key")
        end
      end

      context "key with forward slash" do
        let(:arguments) { "'test/key'" }
        it "should use the given key since it's valid" do
          expect(tag.key).to eq testkey("test/key")
        end
      end

      context "key with backward slash" do
        let(:arguments) { "'test\\key'" }
        it "should use the given key since it's valid" do
          expect(tag.key).to eq testkey("test\\key")
        end
      end
    end

    context "cleaning" do
      context "key with single quote" do
        let(:arguments) { "'single-quote-key'" }
        it "should remove single quote" do
          expect(tag.key).to eq testkey("single-quote-key")
        end
      end

      context "key with double quote" do
        let(:arguments) { '"double-quote-key"' }
        it "should remove double quote" do
          expect(tag.key).to eq testkey("double-quote-key")
        end
      end

      context "key wrapped by slashes" do
        let(:arguments) { "'/slash-key/'" }
        it "should remove the slashes" do
          expect(tag.key).to eq testkey("slash-key")
        end
      end

      context "key with whitespace around it" do
        let(:arguments) { "'   whitespace-key   '" }
        it "should remove the whitespace" do
          expect(tag.key).to eq testkey("whitespace-key")
        end
      end
    end

    context "sequence" do
      let(:arguments) { "'one', 'two', 'three'" }
      it "should combine into single key" do
        expect(tag.key).to eq testkey("one/two/three")
      end
    end

    context "variable in key" do
      context "variable is entire key" do
        let(:environment) { { 'foo' => 'bar' } }
        let(:arguments) { 'foo' }
        it "should evaluate the variable" do
          expect(tag.key).to eq testkey("bar")
        end
      end

      context "variable in sequence" do
        let(:environment) { { 'foo' => 'bar' } }
        let(:arguments) { "'test', foo, 'key'" }
        it "should evaluate the variable in context" do
          expect(tag.key).to eq testkey("test/bar/key")
        end
      end
    end

  end

  def testkey(key)
    return "#{key_prefix}/#{key}"
  end

end


