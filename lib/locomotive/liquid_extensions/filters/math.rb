module Locomotive
  module LiquidExtensions
    module Filters
      module Math

        def mod(input, modulus)
          input.to_i % modulus.to_i
        end

      end
      ::Liquid::Template.register_filter(Math)
    end
  end
end
