module Locomotive
  module LiquidExtensions
    module Tags

      class SendEmail < Solid::Block

        # register the tag
        tag_name :send_email

        # not nil if processed from Wagon
        context_attribute :wagon
        context_attribute :host

        def display(options = {}, &block)
          options       = { html: true }.merge(options)
          pony_options  = options_for_pony(options)

          # get the body
          body_name = options.delete(:html) ? :html_body : :body
          pony_options[body_name] = self.render_body(pony_options, &block)

          # send the email if not in Wagon
          if !wagon
            Pony.mail(pony_options)
          else
            self.log_email(pony_options)
          end

          # render an empty string
          ''
        end

        protected

        def render_body(options)
          current_context['send_email'] = options.stringify_keys

          if handle = options.delete(:page_handle)
            page = self.fetch_page(handle)

            if page.nil?
              raise ::Liquid::Error.new(%{[send_email] No page found with "#{handle}" as handle.})
            end

            page.render(current_context)
          else
            yield
          end
        end

        def fetch_page(handle)
          if wagon
            current_context.registers[:mounting_point].pages.values.detect { |page| page.handle == handle }
          else
            current_context.registers[:site].pages.where(handle: handle).first
          end
        end

        def options_for_pony(options)
          unless (smtp_options = self.extract_stmp_options(options)).empty?
            options[:via]         = :smtp
            options[:via_options] = smtp_options
          end

          # attachment?
          if attachment = extract_attachment(options)
            options[:attachments] = attachment
          end

          options
        end

        def extract_stmp_options(options = {})
          {}.tap do |smtp_options|
            options.delete_if do |name, value|
              if name.to_s =~ /^smtp_(.+)/
                smtp_options[$1.to_sym] = value
              end
            end
          end
        end

        def extract_attachment(options = {})
          name, content = nil

          options.delete_if do |key, value|
            if key.to_s =~ /^attachment_(.+)/
              case $1.to_sym
              when :name  then name = value
              when :value then content = read_attachment(value)
              end
            end
          end

          if name.present? && content.present?
            { name => content }
          end
        end

        def read_attachment(value)
          uri_string, inline = case value
          when /^https*:\/\// then [value, false]
          when /^\// then ["http://#{host}#{value}", false]
          else
            [value, true]
          end

          return value if inline

          begin
            uri = URI(uri_string)
            Net::HTTP.get(uri)
          rescue Exception => e
            logger.error "[SendEmail] Unable to read the '#{uri_string}' uri, error: #{e.message}"
            nil
          end
        end

        def log_email(email)
          message = ["Sent email via #{email[:via]} (#{email[:via_options].inspect}):"]
          message << "From:     #{email[:from]}"
          message << "To:       #{email[:to]}"
          message << "Subject:  #{email[:subject]}"
          message << "-----------"
          message << (email[:body] || email[:html_body]).gsub("\n", "\n\t")
          message << "-----------"

          logger.info message.join("\n") + "\n\n"
        end

        def logger
          current_context.registers[:logger]
        end

      end

    end
  end
end