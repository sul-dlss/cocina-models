# frozen_string_literal: true

require 'deprecation'

module Cocina
  module Models
    module Builders
      # TitleBuilder selects the prefered title from the cocina object for solr indexing
      class TitleBuilder # rubocop:disable Metrics/ClassLength
        extend Deprecation
        # @param [[Array<Cocina::Models::Title,Cocina::Models::DescriptiveValue>] titles the titles to consider
        # @param [Symbol] strategy ":first" is the strategy for selection when primary or display
        #   title are missing
        # @param [Boolean] add_punctuation determines if the title should be formmated with punctuation
        # @return [String] the title value for Solr
        def self.build(titles, strategy: :first, add_punctuation: true)
          if titles.respond_to?(:description)
            Deprecation.warn(self,
                             "Calling TitleBuilder.build with a #{titles.class} is deprecated. " \
                             'It must be called with an array of titles')
            titles = titles.description.title
          end
          new(strategy: strategy, add_punctuation: add_punctuation).build(titles)
        end

        # the "main title" is the title withOUT subtitle, part name, etc.  We want to index it separately so
        #   we can boost matches on it in search results (boost matching this string higher than matching full title string)
        #   e.g. "The Hobbit" (main_title) vs "The Hobbit, or, There and Back Again (full_title)
        # @param [[Array<Cocina::Models::Title,Cocina::Models::DescriptiveValue>] titles the titles to consider
        # @return [String] the main title value for Solr
        def self.main_title(titles)
          new(strategy: :first, add_punctuation: false).main_title(titles)
        end

        # the "full title" is the title WITH subtitle, part name, etc.  We want to able able to index it separately so
        #   we can boost matches on it in search results (boost matching this string higher than other titles present)
        # @param [[Array<Cocina::Models::Title,Cocina::Models::DescriptiveValue>] titles the titles to consider
        # @return [String] the title value for Solr
        def self.full_title(titles)
          new(strategy: :first, add_punctuation: false).build(titles)
        end

        def initialize(strategy:, add_punctuation:)
          @strategy = strategy
          @add_punctuation = add_punctuation
        end

        # @param [[Array<Cocina::Models::Title>] cocina_titles the titles to consider
        # @return [String] the title value for Solr
        def build(cocina_titles)
          cocina_title = primary_title(cocina_titles) || untyped_title(cocina_titles)
          cocina_title = other_title(cocina_titles) if cocina_title.blank?

          if strategy == :first
            extract_title(cocina_title)
          else
            cocina_titles.map { |one| extract_title(one) }
          end
        end

        def main_title(titles)
          cocina_title = primary_title(titles) || untyped_title(titles)
          cocina_title = other_title(titles) if cocina_title.blank?

          cocina_title = cocina_title.first if cocina_title.is_a?(Array)
          extract_main_title(cocina_title)
        end

        private

        attr_reader :strategy

        def extract_title(cocina_title)
          result = if cocina_title.value
                     cocina_title.value
                   elsif cocina_title.structuredValue.present?
                     title_from_structured_values(cocina_title)
                   elsif cocina_title.parallelValue.present?
                     return build(cocina_title.parallelValue)
                   end
          remove_trailing_punctuation(result.strip) if result.present?
        end

        def extract_main_title(cocina_title)
          if cocina_title.value
            cocina_title.value # covers both title and main title types
          elsif cocina_title.structuredValue.present?
            main_title_from_structured_values(cocina_title)
          elsif cocina_title.parallelValue.present?
            main_title(cocina_title.parallelValue)
          end
        end

        def add_punctuation?
          @add_punctuation
        end

        # @return [Cocina::Models::Title, nil] title that has status=primary
        def primary_title(titles)
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

        def untyped_title(titles)
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
        def other_title(titles)
          if strategy == :first
            titles.first
          else
            titles
          end
        end

        # @param [Cocina::Models::Title] title with structured values
        # @return [String] the title value from combining the pieces of the structured_values by type and order
        #   with desired punctuation per specs
        #
        # rubocop:disable Metrics/CyclomaticComplexity
        # rubocop:disable Metrics/MethodLength
        # rubocop:disable Metrics/PerceivedComplexity
        def title_from_structured_values(title)
          # parse out the parts
          main_title = ''
          subtitle = ''
          non_sort_value = ''
          part_name_number = ''
          title.structuredValue.each do |structured_value|
            # There can be a structuredValue inside a structuredValue.  For example,
            #   a uniform title where both the name and the title have internal StructuredValue
            return title_from_structured_values(structured_value) if structured_value.structuredValue.present?

            value = structured_value.value&.strip
            next unless value

            # additional types:  name, uniform ...
            case structured_value.type&.downcase
            when 'nonsorting characters'
              non_sort_value = "#{value}#{non_sorting_padding(title, value)}"
            when 'part name', 'part number'
              part_name_number = part_name_number(title.structuredValue) if part_name_number.blank?
            when 'main title', 'title'
              main_title = value
            when 'subtitle'
              # combine multiple subtitles into a single string
              subtitle = if !add_punctuation?
                           if subtitle.present?
                             [subtitle, value].join(' ')
                           else
                             value
                           end
                         elsif subtitle.present?
                           # subtitle is preceded by space colon space, unless it is at the beginning of the title string
                           "#{subtitle.sub(/[. :]+$/, '')} : #{value.sub(/^:/, '').strip}"
                         else
                           value.sub(/^:/, '').strip
                         end
            end
          end

          # combine the parts into a single title string
          if add_punctuation?
            combine_with_punctuation(non_sort_value: non_sort_value, main_title: main_title, subtitle: subtitle,
                                     part_name_number: part_name_number)
          else
            ["#{non_sort_value}#{main_title}", subtitle, part_name_number].select(&:presence).join(' ')
          end
        end
        # rubocop:enable Metrics/CyclomaticComplexity
        # rubocop:enable Metrics/MethodLength
        # rubocop:enable Metrics/PerceivedComplexity

        # main_title is title.structuredValue.value with type 'main title' (or just title.value)
        # @param [Cocina::Models::Title] title with structured values
        # @return [String] the main title value
        def main_title_from_structured_values(cocina_title) # rubocop:disable Metrics/MethodLength
          result = ''
          # combine pieces of the cocina structuredValue into a single title
          cocina_title.structuredValue.each do |structured_value|
            # There can be a structuredValue inside a structuredValue.  For example,
            #   a uniform title where both the name and the title have internal StructuredValue
            return main_title_from_structured_values(structured_value) if structured_value.structuredValue.present?

            value = structured_value.value&.strip
            next unless value

            case structured_value.type&.downcase
            when 'nonsorting characters'
              non_sort_value = "#{value}#{non_sorting_padding(cocina_title, value)}"
              result = "#{non_sort_value}#{result}" # non-sorting characters are at the beginning of the title
            when 'main title'
              result = "#{result}#{value}"
            when 'title'
              result = value
            end
          end
          result
        end

        # Thank MARC and catalog cards for this mess. We need to add punctuation.
        # rubocop:disable Metrics/MethodLength
        def combine_with_punctuation(non_sort_value:, main_title:, subtitle:, part_name_number:)
          result = "#{non_sort_value}#{main_title}"
          if subtitle.present?
            result = if result.present?
                       "#{result.sub(/[. :]+$/, '')} : #{subtitle.sub(/^:/, '').strip}"
                     else
                       result = subtitle
                     end
          end
          if part_name_number.present?
            result = if result.present?
                       "#{result.sub(/[ .,]*$/, '')}. #{part_name_number}."
                     else
                       "#{part_name_number}."
                     end
          end
          result
        end
        # rubocop:enable Metrics/MethodLength

        def remove_trailing_punctuation(title)
          title.sub(%r{[ .,;:/\\]+$}, '')
        end

        def non_sorting_padding(title, non_sorting_value)
          non_sort_note = title.note&.find { |note| note.type&.downcase == 'nonsorting character count' }
          if non_sort_note
            padding_count = [non_sort_note.value.to_i - non_sorting_value.length, 0].max
            ' ' * padding_count
          elsif ['\'', '-'].include?(non_sorting_value.last)
            ''
          else
            ' '
          end
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
    end
  end
end
