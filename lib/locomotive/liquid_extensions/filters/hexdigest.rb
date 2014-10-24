module Locomotive
  module LiquidExtensions
    module Filters
      module Hexdigest

        def hexdigest(input, key, digest = nil)
          OpenSSL::HMAC.hexdigest(digest || 'sha1', key, input)
        end

      end
    end
  end
end
