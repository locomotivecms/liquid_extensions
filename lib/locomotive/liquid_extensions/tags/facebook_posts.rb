require 'httparty'

module Locomotive
  module LiquidExtensions
    module Tags

      class FacebookPosts < Solid::Block

        # register the tag
        tag_name :facebook_posts

        def display(options = {}, &block)
          url = "https://graph.facebook.com/#{options[:account]}/posts"

          response = HTTParty.get(url, query: {
            access_token: options[:access_token],
            limit:        options[:limit] || 1
          })

          render_posts(response.parsed_response['data'], &block)
        end

        protected

        def render_posts(posts, &block)
          html = ''

          if posts
            posts.each do |post|
              attributes = post.slice('name', 'message', 'picture', 'link')

              attributes['created_time'] = DateTime.parse(post['created_time'])

              current_context.stack do
                current_context.merge('facebook_post' => attributes)

                html << yield
              end
            end
          end

          html
        end

      end
    end
  end
end
