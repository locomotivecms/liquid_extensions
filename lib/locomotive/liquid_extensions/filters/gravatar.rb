require 'digest/md5'

module Locomotive
  module LiquidExtensions
    module Filters
      module Gravatar

        def gravatar_url(input)
          cleaned = input.strip.downcase
          hash    = Digest::MD5.hexdigest(cleaned)
          "http://www.gravatar.com/avatar/#{hash}"
        end

        def gravatar_tag(input)
          url = gravatar_url(input)
          "<img src=\"#{url}\" alt=\"Gravatar\" class=\"gravatar\" />"
        end

      end
    end
  end
end
