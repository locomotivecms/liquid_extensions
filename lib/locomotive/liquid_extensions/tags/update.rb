module Locomotive
  module LiquidExtensions
    module Tags

      class Update < Solid::ConditionalBlock

        # register the tag
        tag_name :update

        # not nil if processed from Wagon
        context_attribute :wagon

        def display(*options)
          drop, attributes = self.extract_drop_and_attributes(options)
          model = drop.try(:_source)

          return yield(false) if model.nil?

          # set the new attributes
          model.attributes = attributes

          # save the model in the engine or just process the validation if in Wagon
          persisted = wagon ? model.valid? : model.save

          # log the last statement
          self.log(model, persisted)

          yield(persisted)
        end

        protected

        def extract_drop_and_attributes(options)
          raise Liquid::Error.new('[update] wrong number of parameters (2 are required)') if options.size != 2

          [options.first, options.last].tap do |drop, attributes|
            if attributes.is_a?(Hash)
              attributes.each do |k, v|
                # deal with the model directly instead of the liquid drop
                attributes[k] = v._source if v.respond_to?(:_source)
              end
            else
              raise Liquid::Error.new('[update] wrong attributes')
            end
          end
        end

        def log(model, persisted)
          message = persisted ? ["Model updated !"] : ["Model not updated :-("]
          message << "  attributes: #{model.to_s}"

          current_context.registers[:logger].info message.join("\n") + "\n\n"
        end

      end

    end
  end
end