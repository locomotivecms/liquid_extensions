module Locomotive
  module LiquidExtensions
    module Filters
      module Sample

        def sample(input, number)
          if input.respond_to?(:all) # Content type collection
            input.all.sample(number)
          else
            input.sample(number)
          end
        end

      end

    end
  end
end