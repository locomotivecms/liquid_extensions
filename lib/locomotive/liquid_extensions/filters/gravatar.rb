require 'digest/md5'

module Locomotive
  module LiquidExtensions
    module Filters
      module Gravatar

        def gravatar_url(input, *opts)
          cleaned = input.strip.downcase
          hash    = Digest::MD5.hexdigest(cleaned)
          url     = "http://www.gravatar.com/avatar/#{hash}"

          params = {}
          opts.each do |opt|
            if m = /^s(ize)?:(\d+)$/i.match(opt)
              params[:s] = m[2]
            elsif m = /^d(default)?:(\w+)$/i.match(opt)
              params[:d] = m[2].downcase
            elsif m = /^r(ating)?:(g|pg|r|x)$/i.match(opt)
              params[:r] = m[2].downcase
            end
          end

          if params.empty?
            url
          else
            param_str = params.map{|k,v| "#{k}=#{v}"}.join('&')
            "#{url}?#{param_str}"
          end
        end

        def gravatar_tag(input, *opts)
          url = gravatar_url(input, *opts).gsub('&', '&amp;')
          "<img src=\"#{url}\" alt=\"Gravatar\" class=\"gravatar\" />"
        end

      end
    end
  end
end
