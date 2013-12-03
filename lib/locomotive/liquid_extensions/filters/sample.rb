module Locomotive
  module LiquidExtensions
    module Filters
      module Sample

        def sample(input, number = 1)
          if input.respond_to?(:all) # Content type collection
            number > 1 ? input.all.sample(number) : input.all.sample
          else
            number > 1 ? input.sample(number) : input.sample
          end
        end

      end

    end
  end
end