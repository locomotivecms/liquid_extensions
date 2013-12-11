module Locomotive
  module LiquidExtensions
    module Tags

      class For < ::Liquid::For

        def initialize(tag_name, markup, tokens, context)
          super

          if @attributes['join']
            @attributes['join'] = remove_quotes(@attributes['join'])
          end
        end

        def render_all(nodes, context)
          separator = @attributes['join']
          content   = super

          if context['forloop']['last'] || separator.blank?
            separator = ''
          end

          content + separator
        end

        protected

        def remove_quotes(string)
          # more leading and trailling quotes (simple or double)
          string.gsub(/^(['"]+)/, '').gsub(/(['"]+)$/, '')
        end

      end

      ::Liquid::Template.register_tag('for', For)

    end
  end
end