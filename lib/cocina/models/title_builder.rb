# frozen_string_literal: true

module Cocina
  module Models
    # TitleBuilder selects the prefered title from the cocina object for solr indexing
    # rubocop:disable Metrics/ClassLength
    class TitleBuilder
      # @param [Cocina::Models::D*] cocina_object is the object to extract the title for
      # @param [Symbol] strategy ":first" is the strategy for selection when primary or display title are missing
      # @param [Boolean] add_punctuation determines if the title should be formmated with punctuation
      # @return [String] the title value for Solr
      def self.build(cocina_object, strategy: :first, add_punctuation: true)
        new(cocina_object, strategy: strategy, add_punctuation: add_punctuation).build_title
      end

      def initialize(cocina_object, strategy:, add_punctuation:)
        @cocina_object = cocina_object
        @strategy = strategy
        @add_punctuation = add_punctuation
      end

      # @return [String] the title value for Solr
      def build_title
        @titles = cocina_object.description.title

        cocina_title = primary_title || untyped_title
        cocina_title = other_title if cocina_title.blank?

        if strategy == :first
          extract_title(cocina_title)
        else
          cocina_title.map { |one| extract_title(one) }
        end
      end

      private

      attr_reader :cocina_object, :strategy, :titles

      def extract_title(cocina_title)
        result = if cocina_title.value
                   cocina_title.value
                 elsif cocina_title.structuredValue.present?
                   title_from_structured_values(cocina_title.structuredValue,
                                                non_sorting_char_count(cocina_title))
                 elsif cocina_title.parallelValue.present?
                   return cocina_title.parallelValue.first.value
                 end
        remove_trailing_punctuation(result.strip) if result.present?
      end

      def add_punctuation?
        @add_punctuation
      end

      # @return [Cocina::Models::Title, nil] title that has status=primary
      def primary_title
        primary_title = titles.find do |title|
          title.status == 'primary'
        end
        return primary_title if primary_title.present?

        # NOTE: structuredValues would only have status primary assigned as a sibling, not as an attribute

        titles.find do |title|
          title.parallelValue&.find do |parallel_title|
            parallel_title.status == 'primary'
          end
        end
      end

      def untyped_title
        method = strategy == :first ? :find : :select
        untyped_title_for(titles.public_send(method))
      end

      # @return [Array[Cocina::Models::Title]] first title that has no type attribute
      def untyped_title_for(titles)
        titles.each do |title|
          if title.parallelValue.present?
            untyped_title_for(title.parallelValue)
          else
            title.type.nil? || title.type == 'title'
          end
        end
      end

      # This handles 'main title', 'uniform' or 'translated'
      def other_title
        if strategy == :first
          titles.first
        else
          titles
        end
      end

      # rubocop:disable Metrics/BlockLength
      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/PerceivedComplexity
      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/AbcSize
      # @param [Array<Cocina::Models::StructuredValue>] structured_values - the pieces of a structuredValue
      # @param [Integer] the length of the non_sorting_characters
      # @return [String] the title value from combining the pieces of the structured_values by type and order
      #   with desired punctuation per specs
      def title_from_structured_values(structured_values, non_sorting_char_count)
        structured_title = ''
        part_name_number = ''
        # combine pieces of the cocina structuredValue into a single title
        structured_values.each do |structured_value|
          # There can be a structuredValue inside a structuredValue.  For example,
          #   a uniform title where both the name and the title have internal StructuredValue
          if structured_value.structuredValue.present?
            return title_from_structured_values(structured_value.structuredValue, non_sorting_char_count)
          end

          value = structured_value.value&.strip
          next unless value

          # additional types:  name, uniform ...
          case structured_value.type&.downcase
          when 'nonsorting characters'
            non_sorting_size = [non_sorting_char_count - (value&.size || 0), 0].max
            non_sort_value = "#{value}#{' ' * non_sorting_size}"
            structured_title = if structured_title.present?
                                 "#{structured_title}#{non_sort_value}"
                               else
                                 non_sort_value
                               end
          when 'part name', 'part number'
            if part_name_number.blank?
              part_name_number = part_name_number(structured_values)
              structured_title = if !add_punctuation?
                                   [structured_title, part_name_number].join(' ')
                                 elsif structured_title.present?
                                   "#{structured_title.sub(/[ .,]*$/, '')}. #{part_name_number}. "
                                 else
                                   "#{part_name_number}. "
                                 end
            end
          when 'main title', 'title'
            structured_title = "#{structured_title}#{value}"
          when 'subtitle'
            # subtitle is preceded by space colon space, unless it is at the beginning of the title string
            structured_title = if !add_punctuation?
                                 [structured_title, value].join(' ')
                               elsif structured_title.present?
                                 "#{structured_title.sub(/[. :]+$/, '')} : #{value.sub(/^:/, '').strip}"
                               else
                                 structured_title = value.sub(/^:/, '').strip
                               end
          end
        end
        structured_title
      end
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/BlockLength
      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/PerceivedComplexity

      def remove_trailing_punctuation(title)
        title.sub(%r{[ .,;:/\\]+$}, '')
      end

      def non_sorting_char_count(title)
        non_sort_note = title.note&.find { |note| note.type&.downcase == 'nonsorting character count' }
        return 0 unless non_sort_note

        non_sort_note.value.to_i
      end

      # combine part name and part number:
      #   respect order of occurrence
      #   separated from each other by comma space
      def part_name_number(structured_values)
        title_from_part = ''
        structured_values.each do |structured_value|
          case structured_value.type&.downcase
          when 'part name', 'part number'
            value = structured_value.value&.strip
            next unless value

            title_from_part = append_part_to_title(title_from_part, value)

          end
        end
        title_from_part
      end

      def append_part_to_title(title_from_part, value)
        if !add_punctuation?
          [title_from_part, value].select(&:presence).join(' ')
        elsif title_from_part.strip.present?
          "#{title_from_part.sub(/[ .,]*$/, '')}, #{value}"
        else
          value
        end
      end
    end
    # rubocop:enable Metrics/ClassLength
  end
end