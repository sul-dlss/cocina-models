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
        #     look for cocina title properties :value or :structured_value (recurse down through :parallel_value
        #     as needed), and look for associated :note with :type of "associated name" at the level of the
        #     non-empty title [value|structured_value]
        #     The note of type "associated name" will have [value|structured_value] which will match
        #     [value|structured_value] for a contributor (possibly after recursing through :parallel_value).
        #   Thus, a title [value|structured_value] and a contributor [value|structured_value] are associated in
        #   cocina.
        #
        # If those criteria not met in Cocina, do not assign nameTitleGroup in MODS
        #
        # @params [Cocina::Models::Title] title
        # @return [Hash<Hash, Hash>] key:  hash of value or structured_value property for title
        #   value: hash of value or structured_value property for contributor
        #   e.g. {{:value=>"Portrait of the artist as a young man"}=>{:value=>"James Joyce"}}
        #   e.g. {{:value=>"Portrait of the artist as a young man"}=>{:structured_value=>
        #         [{:value=>"Joyce, James", :type=>"name"},{:value=>"1882-1941", :type=>"life dates"}]}}
        #   e.g. {{:structured_value=>[{:value=>"Demanding Food", :type=>"main"},
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
            #     structured_value: [ structured_value contributor name ],
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
        #   hashes containing (either :value or :structured_value)
        # rubocop:disable Metrics/AbcSize
        def self.value_slices(desc_value)
          slices = []
          desc_value_slice = desc_value.to_h.slice(:value, :structured_value, :parallel_value)
          if desc_value_slice[:value].present? || desc_value_slice[:structured_value].present?
            slices << desc_value_slice.select { |_k, value| value.present? }
          elsif desc_value_slice[:parallel_value].present?
            desc_value_slice[:parallel_value].each { |parallel_val| slices << value_slices(parallel_val) }
          end
          # ignoring grouped_value
          slices.flatten
        end
        # rubocop:enable Metrics/AbcSize
        # private_class_method :value_slices

        # for a given Hash (from a Cocina DescriptiveValue or Title or Name or ...)
        # result will be either
        #   { value: 'string value' }
        # OR
        #   { structured_value: [ some structured_value ] }
        def self.slice_of_value_or_structured_value(hash)
          if hash[:value].present?
            hash.slice(:value).select { |_k, value| value.present? }
          elsif hash[:structured_value].present?
            hash.slice(:structured_value).select { |_k, value| value.present? }
          end
        end

        # reduce parallel_values down to value or structured_value for these slices
        # @params [Cocina::Models::Title] title
        # @return [Array<Cocina::Models::DescriptiveValue>] where we are only interested in
        #   hashes containing (either :value or :structureValue) and :note if present
        # rubocop:disable Metrics/AbcSize
        def self.title_value_note_slices(title)
          slices = []
          title_slice = title.to_h.slice(:value, :structured_value, :parallel_value, :note)
          if title_slice[:value].present? || title_slice[:structured_value].present?
            slices << title_slice.select { |_k, value| value.present? }
          elsif title_slice[:parallel_value].present?
            title_slice[:parallel_value].each do |parallel_val|
              slices << title_value_note_slices(parallel_val)
            end
          end
          # ignoring grouped_value
          slices.flatten
        end
        # rubocop:enable Metrics/AbcSize
      end
    end
  end
end
