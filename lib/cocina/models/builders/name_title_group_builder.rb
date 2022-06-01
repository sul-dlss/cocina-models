# frozen_string_literal: true

module Cocina
  module Models
    module Builders
      # Helpers for MODS nameTitleGroups.
      #   MODS titles need to know if they match a contributor and thus need a nameTitleGroup
      #   MODS contributors need to know if they match a title and thus need a nameTitleGroup
      #     If there is a match, the nameTitleGroup number has to be consistent for the matching title(s)
      #     and the contributor(s)
      class NameTitleGroupBuilder
        # When to assign nameTitleGroup to MODS from cocina:
        #   for cocina title of type "uniform",
        #     look for cocina title properties :value or :structuredValue (recurse down through :parallelValue
        #     as needed), and look for associated :note with :type of "associated name" at the level of the
        #     non-empty title [value|structuredValue]
        #     The note of type "associated name" will have [value|structuredValue] which will match
        #     [value|structuredValue] for a contributor (possibly after recursing through :parallelValue).
        #   Thus, a title [value|structuredValue] and a contributor [value|structuredValue] are associated in
        #   cocina.
        #
        # If those criteria not met in Cocina, do not assign nameTitleGroup in MODS
        #
        # @params [Cocina::Models::Title] title
        # @return [Hash<Hash, Hash>] key:  hash of value or structuredValue property for title
        #   value: hash of value or structuredValue property for contributor
        #   e.g. {{:value=>"Portrait of the artist as a young man"}=>{:value=>"James Joyce"}}
        #   e.g. {{:value=>"Portrait of the artist as a young man"}=>{:structuredValue=>
        #         [{:value=>"Joyce, James", :type=>"name"},{:value=>"1882-1941", :type=>"life dates"}]}}
        #   e.g. {{:structuredValue=>[{:value=>"Demanding Food", :type=>"main"},
        #           {:value=>"A Cat's Life", :type=>"subtitle"}]}=>{:value=>"James Joyce"}}
        #   this complexity is needed for multilingual titles mapping to multilingual names.
        def self.build_title_values_to_contributor_name_values(title)
          result = {}
          return result if title.blank?

          # pair title value with contributor name value
          title_value_note_slices(title).each do |value_note_slice|
            title_val_slice = slice_of_value_or_structured_value(value_note_slice)
            next if title_val_slice.blank?

            associated_name_note = value_note_slice[:note]&.detect { |note| note[:type] == 'associated name' }
            next if associated_name_note.blank?

            # relevant note will be Array of either
            #   {
            #     value: 'string contributor name',
            #     type: 'associated name'
            #   }
            # OR
            #   {
            #     structuredValue: [ structuredValue contributor name ],
            #     type: 'associated name'
            #   }
            # and we want the hash without the :type attribute
            result[title_val_slice] = slice_of_value_or_structured_value(associated_name_note)
          end
          result
        end

        def self.contributor_for_contributor_name_value_slice(contributor_name_value_slice:, contributors:)
          Array(contributors).find do |contributor|
            contrib_name_value_slices = contributor_name_value_slices(contributor)
            contrib_name_value_slices.include?(contributor_name_value_slice)
          end
        end

        # @params [Cocina::Models::Contributor] contributor
        # @return [Hash] where we are only interested in
        #   hashes containing (either :value or :structureValue)
        def self.contributor_name_value_slices(contributor)
          return if contributor&.name.blank?

          slices = []
          Array(contributor.name).each do |contrib_name|
            slices << value_slices(contrib_name)
          end
          slices.flatten
        end

        # @params [Cocina::Models::DescriptiveValue] desc_value
        # @return [Array<Cocina::Models::DescriptiveValue>] where we are only interested in
        #   hashes containing (either :value or :structuredValue)
        def self.value_slices(desc_value)
          slices = []
          desc_value_slice = desc_value.to_h.slice(:value, :structuredValue, :parallelValue)
          if desc_value_slice[:value].present? || desc_value_slice[:structuredValue].present?
            slices << desc_value_slice.select { |_k, value| value.present? }
          elsif desc_value_slice[:parallelValue].present?
            desc_value_slice[:parallelValue].each { |parallel_val| slices << value_slices(parallel_val) }
          end
          # ignoring groupedValue
          slices.flatten
        end

        # for a given Hash (from a Cocina DescriptiveValue or Title or Name or ...)
        # result will be either
        #   { value: 'string value' }
        # OR
        #   { structuredValue: [ some structuredValue ] }
        def self.slice_of_value_or_structured_value(hash)
          if hash[:value].present?
            hash.slice(:value).select { |_k, value| value.present? }
          elsif hash[:structuredValue].present?
            hash.slice(:structuredValue).select { |_k, value| value.present? }
          end
        end

        # reduce parallelValues down to value or structuredValue for these slices
        # @params [Cocina::Models::Title] title
        # @return [Array<Cocina::Models::DescriptiveValue>] where we are only interested in
        #   hashes containing (either :value or :structureValue) and :note if present
        def self.title_value_note_slices(title)
          slices = []
          title_slice = title.to_h.slice(:value, :structuredValue, :parallelValue, :note)
          if title_slice[:value].present? || title_slice[:structuredValue].present?
            slices << title_slice.select { |_k, value| value.present? }
          elsif title_slice[:parallelValue].present?
            title_slice[:parallelValue].each do |parallel_val|
              slices << title_value_note_slices(parallel_val)
            end
          end
          # ignoring groupedValue
          slices.flatten
        end
      end
    end
  end
end
