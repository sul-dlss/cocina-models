# frozen_string_literal: true

module Cocina
  module Models
    module Mapping
      module ToMods
        # Maps contributors from cocina to MODS XML
        class Contributor
          # one way mapping:  MODS 'corporate' already maps to Cocina 'organization'
          NAME_TYPE = Cocina::Models::Mapping::FromMods::Contributor::ROLES.invert.merge('event' => 'corporate').freeze
          NAME_PART = Cocina::Models::Mapping::FromMods::Contributor::NAME_PART.invert.freeze

          # NOTE: contributors in nameTitleGroups are output as part of Title.
          # @params [Nokogiri::XML::Builder] xml
          # @params [Array<Cocina::Models::Contributor>] contributors
          # @params [Array<Cocina::Models::Title>] titles
          # @params [IdGenerator] id_generator
          def self.write(xml:, contributors:, titles:, id_generator:)
            new(xml: xml, contributors: contributors, titles: titles, id_generator: id_generator).write
          end

          def initialize(xml:, contributors:, titles:, id_generator:)
            @xml = xml
            @contributors = contributors
            @titles = titles
            @id_generator = id_generator
          end

          # NOTE: contributors in nameTitleGroups are output as part of Title.
          def write
            Array(contributors)
              .reject do |contributor|
              NameTitleGroup.in_name_title_group?(contributor: contributor,
                                                  titles: titles)
            end
              .each do |contributor|
              NameWriter.write(xml: xml, contributor: contributor,
                               id_generator: id_generator)
            end
          end

          private

          attr_reader :xml, :contributors, :titles, :id_generator
        end
      end
    end
  end
end
