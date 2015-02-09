require 'json'

module Locomotive
  module LiquidExtensions
    module Filters
      module ParseJson

        def as_json(input, fields = nil)
          JSON.parse(input)
        rescue JSON::ParserError
          "JSON has wrong format"
        end

      end
    end
  end
end
