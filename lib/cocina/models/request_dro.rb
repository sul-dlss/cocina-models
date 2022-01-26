# frozen_string_literal: true

module Cocina
  module Models
    class RequestDRO < Struct
      include Checkable

      TYPES = ['http://cocina.sul.stanford.edu/models/object.jsonld',
               'http://cocina.sul.stanford.edu/models/3d.jsonld',
               'http://cocina.sul.stanford.edu/models/agreement.jsonld',
               'http://cocina.sul.stanford.edu/models/book.jsonld',
               'http://cocina.sul.stanford.edu/models/document.jsonld',
               'http://cocina.sul.stanford.edu/models/geo.jsonld',
               'http://cocina.sul.stanford.edu/models/image.jsonld',
               'http://cocina.sul.stanford.edu/models/page.jsonld',
               'http://cocina.sul.stanford.edu/models/photograph.jsonld',
               'http://cocina.sul.stanford.edu/models/manuscript.jsonld',
               'http://cocina.sul.stanford.edu/models/map.jsonld',
               'http://cocina.sul.stanford.edu/models/media.jsonld',
               'http://cocina.sul.stanford.edu/models/track.jsonld',
               'http://cocina.sul.stanford.edu/models/webarchive-binary.jsonld',
               'http://cocina.sul.stanford.edu/models/webarchive-seed.jsonld'].freeze

      # The version of Cocina with which this object conforms.
      # example: 1.2.3
      attribute :cocinaVersion, Types::Strict::String.default(Cocina::Models::VERSION)
      attribute :type, Types::Strict::String.enum(*RequestDRO::TYPES)
      attribute :label, Types::Strict::String
      attribute :version, Types::Strict::Integer
      attribute :access, DROAccess.optional.meta(omittable: true)
      attribute(:administrative, Administrative.default { Administrative.new })
      attribute :description, RequestDescription.optional.meta(omittable: true)
      attribute(:identification, RequestIdentification.default { RequestIdentification.new })
      attribute :structural, RequestDROStructural.optional.meta(omittable: true)
      attribute :geographic, Geographic.optional.meta(omittable: true)

      def self.new(attributes = default_attributes, safe = false, validate = true, &block)
        Validator.validate(self, attributes.with_indifferent_access) if validate && name
        super(attributes, safe, &block)
      end
    end
  end
end
