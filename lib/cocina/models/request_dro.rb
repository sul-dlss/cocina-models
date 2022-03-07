# frozen_string_literal: true

module Cocina
  module Models
    class RequestDRO < Struct
      include Validatable

      include Checkable

      include TitleBuilder

      TYPES = ['https://cocina.sul.stanford.edu/models/object',
               'https://cocina.sul.stanford.edu/models/3d',
               'https://cocina.sul.stanford.edu/models/agreement',
               'https://cocina.sul.stanford.edu/models/book',
               'https://cocina.sul.stanford.edu/models/document',
               'https://cocina.sul.stanford.edu/models/geo',
               'https://cocina.sul.stanford.edu/models/image',
               'https://cocina.sul.stanford.edu/models/page',
               'https://cocina.sul.stanford.edu/models/photograph',
               'https://cocina.sul.stanford.edu/models/manuscript',
               'https://cocina.sul.stanford.edu/models/map',
               'https://cocina.sul.stanford.edu/models/media',
               'https://cocina.sul.stanford.edu/models/track',
               'https://cocina.sul.stanford.edu/models/webarchive-binary',
               'https://cocina.sul.stanford.edu/models/webarchive-seed'].freeze

      # The version of Cocina with which this object conforms.
      # example: 1.2.3
      attribute :cocinaVersion, Types::Strict::String.default(Cocina::Models::VERSION)
      attribute :type, Types::Strict::String.enum(*RequestDRO::TYPES)
      attribute :label, Types::Strict::String
      attribute :version, Types::Strict::Integer.default(1).enum(1)
      attribute :access, DROAccess.optional.meta(omittable: true)
      attribute(:administrative, RequestAdministrative.default { RequestAdministrative.new })
      attribute :description, RequestDescription.optional.meta(omittable: true)
      attribute(:identification, RequestIdentification.default { RequestIdentification.new })
      attribute :structural, RequestDROStructural.optional.meta(omittable: true)
      attribute :geographic, Geographic.optional.meta(omittable: true)
    end
  end
end
