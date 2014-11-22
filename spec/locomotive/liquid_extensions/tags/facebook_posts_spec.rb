require 'spec_helper'

describe Locomotive::LiquidExtensions::Tags::FacebookPosts do

  let(:tag_class) { Locomotive::LiquidExtensions::Tags::FacebookPosts }

  describe '#display' do

    let(:account)       { ENV['FACEBOOK_ACCOUNT'] || '' }
    let(:access_token)  { ENV['FACEBOOK_ACCESS_TOKEN'] || '' }
    let(:limit)         { 2 }

    let(:template)  { %(
      {% facebook_posts account: '#{account}', access_token: '#{access_token}', limit: #{limit} %}
      {{ facebook_post.name }}
      {% endfacebook_posts %})
    }
    let(:assigns)   { {} }
    let(:context)   { Liquid::Context.new({}, assigns, { logger: CustomLogger }) }

    subject { ::Liquid::Template.parse(template).render(context).strip }

    describe 'live environment', if: ENV['FACEBOOK_ACCOUNT'] do

      it 'returns something not blank' do
        expect(subject).not_to eq ''
      end

      describe 'invalid access token' do

        let(:access_token) { 'foo' }

        it 'returns something not blank' do
          expect(subject).to eq ''
        end

      end

      describe 'invalid account' do

        let(:account) { '' }

        it 'returns something not blank' do
          expect(subject).to eq ''
        end

      end

    end

    context 'stubbing HTTParty' do

      context 'a list of 2 entries' do

        let(:template)  { %(
          {% facebook_posts account: '#{account}', access_token: '#{access_token}', limit: #{limit} %}-{{ facebook_post.name }}-{% endfacebook_posts %})
        }

        let(:response) {
          [
            { 'name' => 'Hello world', 'created_time' => '2014-11-21T17:00:01+0000' },
            { 'name' => 'Lorem ipsum', 'created_time' => '2014-11-19T20:05:01+0000' }
          ]
        }

        before { mock_httparty(response) }

        it 'displays the names of the posts' do
          expect(subject).to eq "-Hello world--Lorem ipsum-"
        end

        describe 'parsing dates' do

          let(:template)  { %(
            {% facebook_posts account: '#{account}', access_token: '#{access_token}', limit: #{limit} %}-{{ facebook_post.created_time | date: "%a, %d %b %Y" }}-{% endfacebook_posts %})
          }

          it 'displays the dates of the posts' do
            expect(subject).to eq "-Fri, 21 Nov 2014--Wed, 19 Nov 2014-"
          end

        end

      end

    end

  end

  def mock_httparty(response)
    HTTParty.expects(:get).with("https://graph.facebook.com/#{account}/posts", query: {
      access_token: access_token,
      limit: limit
    }).returns(FakeResponse.new(response))
  end

  class FakeResponse

    attr_reader :parsed_response

    def initialize(list)
      @parsed_response = { 'data' => list }
    end

  end
end
