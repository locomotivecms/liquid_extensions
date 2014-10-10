module Locomotive
  module LiquidExtensions
    module Filters
      module Number

        def money(input, *options)
          ProxyHelper.new(:currency, @context).invoke(input, options)
        end

        def percentage(input, *options)
          ProxyHelper.new(:percentage, @context).invoke(input, options)
        end

        class ProxyHelper

          include ActionView::Helpers::NumberHelper

          def initialize(name, context)
            @name     = name
            @context  = context
          end

          def invoke(input, options)
            _options = parse_and_interpolate_options(options)
            send :"number_to_#{@name}", input, _options
          end

          def parse_and_interpolate_options(string_or_array)
            return {} if string_or_array.empty?

            string = [*string_or_array].flatten.join(', ')
            arguments = Solid::Arguments.parse(string)

            (arguments.interpolate(@context).first || {})
          end

        end

      end

    end
  end
end