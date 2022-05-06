# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Validates that when title.note with type "associated name" has a value, it must match a contributor name.
      class AssociatedNameValidator
        def self.validate(clazz, attributes)
          new(clazz, attributes).validate
        end

        def initialize(clazz, attributes)
          @clazz = clazz
          @attributes = attributes.deep_symbolize_keys
          @error_paths = []
        end

        def validate
          return unless meets_preconditions?

          return if resources.all? { |resource| valid?(resource) }

          raise ValidationError,
                'Missing data: Name associated with uniform title does not match any contributor.'
        end

        private

        attr_reader :clazz, :attributes, :error_paths

        def meets_preconditions?
          [Cocina::Models::Description, Cocina::Models::RequestDescription].include?(clazz)
        end

        def valid?(resource)
          titles_with_associated_name_note_for(resource).all? do |title|
            contributor_name_value_slices = Builders::NameTitleGroupBuilder
                                            .build_title_values_to_contributor_name_values(
                                              Cocina::Models::Title.new(title)
                                            ).values
            contributor_name_value_slices.all? do |contributor_name_value_slice|
              contributors = Array(resource[:contributor]).map do |contributor|
                Cocina::Models::Contributor.new(contributor)
              end
              Builders::NameTitleGroupBuilder.contributor_for_contributor_name_value_slice(
                contributor_name_value_slice: contributor_name_value_slice, contributors: contributors
              ).present?
            end
          end
        end

        def resources
          @resources ||= [description_attributes] + Array(description_attributes[:relatedResource])
        end

        def description_attributes
          @description_attributes ||= if [Cocina::Models::Description,
                                          Cocina::Models::RequestDescription].include?(clazz)
                                        attributes
                                      else
                                        attributes[:description] || {}
                                      end
        end

        def associated_name_note_for(title)
          Array(title[:note]).detect { |note| note[:type] == 'associated name' }
        end

        def titles_with_associated_name_note_for(resource)
          Array(resource[:title]).select { |title| associated_name_note_for(title).present? }
        end
      end
    end
  end
end
