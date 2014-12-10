module Locomotive
  module LiquidExtensions
    module Tags

      class Cacher < Solid::Block

        SEPARATOR = "/"
        ERROR_CACHE_KEY_REQUIRED = "Cache key required"
        CACHE_KEY_ROOT_NAMESPACE = "locomotive"

        attr_accessor :key

        def initialize(tag_name, arguments, tokens, context)
          # little hack to make it work with Liquid 2.6.2
          @options = context

          super

          @context  = context
        end

        def display(*values)
          self.key = cache_key(values)
          return cache_mechanism.fetch(self.key) do
            log("render", "cache miss: fetching [#{self.key}]")
            yield
          end
        end

      protected

        def cache_key(user_keys)
          # block must contain a key
          raise ERROR_CACHE_KEY_REQUIRED if user_keys.empty?

          # start all keys with namespace
          key_parts = [CACHE_KEY_ROOT_NAMESPACE]

          # add each user part after cleaning
          user_keys.each do |key|
            key_parts << clean(key) unless key.blank?
          end

          # join composite key parts into single key string using separator
          return key_parts.join(SEPARATOR)
        end

        def clean(s)
          # remove quotes and surrounding whitespace
          return remove_quotes(s).strip
        end

        def remove_quotes(string)
          # more leading and trailling quotes (simple or double)
          string.gsub(/^([\/'"]+)/, '').gsub(/([\/'"]+)$/, '')
        end

        def cache_mechanism
          if Gem::Specification::find_all_by_name('rails').any?
            return Rails.cache
          else
            # return a generic cache object -- WILL NOT ACTUALLY CACHE
            return ActiveSupport::Cache.lookup_store(:memory_store)
          end
        end

        def log(method, s)
          puts "Locomotive::LiquidExtensions::Tags::Cacher##{method}\t#{s}" if ENV["RAILS_ENV"] == "development"
        end

      end

      ::Liquid::Template.register_tag('cache', Cacher)

    end
  end
end
