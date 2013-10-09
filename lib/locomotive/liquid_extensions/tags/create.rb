module Locomotive
  module LiquidExtensions
    module Tags

      class Create < Solid::ConditionalBlock

        # register the tag
        tag_name :create

        # not nil if processed from Wagon
        context_attribute :wagon

        def display(*options)
          model_name, attributes = self.extract_model_name_and_attributes(options)

          model = self.build_model(model_name, attributes)

          return "Unknown #{model_name}" if model.nil?

          # save the model in the engine or just process the validation if in Wagon
          persisted = wagon ? model.valid? : model.save

          # log the last statement
          self.log(model, persisted)

          current_context.stack do
            current_context[model_name.singularize] = model
            current_context['new_entry'] = model

            yield(persisted)
          end
        end

        protected

        def build_model(model_name, attributes)
          content_type = self.fetch_content_type(model_name)

          return nil if content_type.nil?

          if wagon
            content_type.build_entry(attributes)
          else
            content_type.entries.build(attributes)
          end
        end

        def fetch_content_type(model_name)
          if wagon
            current_context.registers[:mounting_point].content_types[model_name]
          else
            current_context.registers[:site].content_types.where(slug: model_name).first
          end
        end

        def extract_model_name_and_attributes(options)
          raise Liquid::Error.new('[create] wrong number of parameters (2 are required)') if options.size != 2

          [options.first.to_s, options.last].tap do |name, attributes|
            if attributes.is_a?(Hash)
              attributes.each do |k, v|
                # deal with the model directly instead of the liquid drop
                _source = v.instance_variable_get(:@_source)

                attributes[k] = _source if _source
              end

              # the content entry should not be attached to another site or content type
              attributes.delete_if { |k, _| %w(site site_id content_type content_type_id).include?(k) }
            else
              raise Liquid::Error.new('[create] wrong attributes')
            end
          end
        end

        def log(model, persisted)
          message = persisted ? ["Model created !"] : ["Model not created :-("]
          message << "  attributes: #{model.to_s}"

          current_context.registers[:logger].info message.join("\n") + "\n\n"
        end

      end

    end
  end
end