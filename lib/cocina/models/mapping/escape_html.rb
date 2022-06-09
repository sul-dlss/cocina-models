# frozen_string_literal: true

module Cocina
  module Models
    module Mapping
      # Escaps HTML entities as CDATA for MODS since HTML is not permitted in MODS
      class EscapeHtml
        # @param [String] data
        # @param [Nokogiri::XML::Builder]
        def self.with_cdata(data, builder)
          tokens = data.split(%r{(</?(?:i|cite)>)})
          tokens.map do |token|
            if /\A<.+>\z/.match? token
              builder.cdata(token)
            else
              builder.text(token)
            end
          end
        end
      end
    end
  end
end
