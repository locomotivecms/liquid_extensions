require 'digest/md5'

module Locomotive
  module LiquidExtensions
    module Filters
      module Md5sum

        def md5sum(input)
          Digest::MD5.hexdigest(input)
        end

      end
    end
  end
end
