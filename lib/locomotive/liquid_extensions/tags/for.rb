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

        def render(context)
          super(context).gsub(/#{separator}$/, '')
        end

        def render_all(nodes, context)
          content   = super.strip

          return '' if content.blank?

          if context['forloop']['last'] || separator.blank?
            content
          else
            content + separator
          end
        end

        protected

        def separator
          @attributes['join']
        end

        def remove_quotes(string)
          # more leading and trailling quotes (simple or double)
          string.gsub(/^(['"]+)/, '').gsub(/(['"]+)$/, '')
        end

      end

      ::Liquid::Template.register_tag('for', For)

    end
  end
end