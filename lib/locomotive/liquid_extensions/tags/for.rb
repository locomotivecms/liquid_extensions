module Locomotive
  module LiquidExtensions
    module Tags

      class For < ::Liquid::For

        def initialize(tag_name, markup, tokens, context)
          # little hack to make it work with Liquid 2.6.2
          @options = context

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

        # Dirty hack which is a consequence of the terrible code in the original for tag.
        def strict_parse(markup)
          p = ::Liquid::Parser.new(markup)
          @variable_name = p.consume(:id)
          raise ::Liquid::SyntaxError.new(options[:locale].t("errors.syntax.for_invalid_in"), line)  unless p.id?('in')
          @collection_name = p.expression
          @name = "#{@variable_name}-#{@collection_name}"
          @reversed = p.id?('reversed')

          @attributes = {}
          while p.look(:id) && p.look(:colon, 1)
            # FIXME (Did): patch allowing the join option
            unless attribute = p.id?('limit') || p.id?('offset') || p.id?('join')
              raise ::Liquid::SyntaxError.new(options[:locale].t("errors.syntax.for_invalid_attribute"), line)
            end
            p.consume
            val = p.expression
            @attributes[attribute] = val
          end
          p.consume(:end_of_string)
        end

      end

      ::Liquid::Template.register_tag('for', For)

    end
  end
end