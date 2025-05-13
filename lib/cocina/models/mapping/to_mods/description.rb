# frozen_string_literal: true

require 'nokogiri'

module Cocina
  module Models
    module Mapping
      module ToMods
        # This transforms the DRO.description schema to MODS xml
        class Description
          # @param [Cocina::Models::Description] description
          # @param [string] druid
          # @return [Nokogiri::XML::Document]
          def self.transform(description, druid, identification: nil)
            new(description, druid, identification).transform
          end

          def initialize(description, druid, identification)
            @description = description
            @identification = identification
            @druid = druid
          end

          # @return [Nokogiri::XML::Document]
          def transform
            Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
              xml.mods(mods_attributes) do
                ModsWriter.write(xml: xml, description: description, druid: druid, identification: identification)
              end
            end.doc
          end

          private

          attr_reader :description, :druid, :identification

          def mods_version
            @mods_version ||= begin
              notes = description.adminMetadata&.note || []
              notes.select { |note| note.type == 'record origin' }.each do |note|
                match = /MODS version (\d\.\d)/.match(note.value)
                return match[1] if match
              end
              '3.7'
            end
          end

          def mods_attributes
            {
              'xmlns' => 'http://www.loc.gov/mods/v3',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
              'xmlns:rdf' => 'http://www.w3.org/1999/02/22-rdf-syntax-ns#',
              'xmlns:xlink' => 'http://www.w3.org/1999/xlink',
              'version' => mods_version,
              'xsi:schemaLocation' => "http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-#{mods_version.sub(
                '.', '-'
              )}.xsd"
            }
          end
        end
      end
    end
  end
end
