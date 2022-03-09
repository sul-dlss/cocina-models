# frozen_string_literal: true

module Cocina
  module Models
    # This vocabulary defines the top level object type
    class ObjectType < Vocabulary('https://cocina.sul.stanford.edu/models/')
      property :'3d', method_name: :three_dimensional
      property :admin_policy
      property :agreement
      property :book
      property :collection
      property :'curated-collection'
      property :document
      property :exhibit
      property :file
      property :geo
      property :image
      property :manuscript
      property :map
      property :media
      property :object
      property :page
      property :photograph
      property :series
      property :track
      property :'user-collection'
      property :'webarchive-binary'
      property :'webarchive-seed'
    end
  end
end
