# frozen_string_literal: true

module Cocina
  module RSpec
    # Factories for Cocina model objects.
    class Factories
      # Provides the build method.
      module Methods
        def build(type, ...)
          # If we don't support this factory, maybe factory_bot does.
          Factories.supported_type?(type) ? Factories.build(type, ...) : super
        end
      end

      SUPPORTED_TYPES = %i[
        admin_policy
        admin_policy_with_metadata
        admin_policy_lite
        collection
        collection_with_metadata
        collection_lite
        dro
        dro_with_metadata
        dro_lite
        request_admin_policy
        request_collection
        request_dro
      ].freeze

      def self.supported_type?(type)
        SUPPORTED_TYPES.include?(type)
      end

      WITH_METADATA_SUFFIX = '_with_metadata'

      def self.build(type, attributes = {})
        raise "Unsupported factory type #{type}" unless supported_type?(type)

        build_type = type.to_s.delete_suffix(WITH_METADATA_SUFFIX)

        fixture = public_send("build_#{build_type}".to_sym, attributes) # rubocop:disable Lint/SymbolConversion
        return fixture unless type.end_with?(WITH_METADATA_SUFFIX)

        Cocina::Models.with_metadata(fixture, 'abc123')
      end

      DRO_DEFAULTS = {
        type: Cocina::Models::ObjectType.object,
        id: 'druid:bc234fg5678',
        version: 1,
        label: 'factory DRO label',
        title: 'factory DRO title',
        source_id: 'sul:1234',
        admin_policy_id: 'druid:hv992ry2431'
      }.freeze

      REQUEST_DRO_DEFAULTS = DRO_DEFAULTS.except(:id)

      COLLECTION_DEFAULTS = {
        type: Cocina::Models::ObjectType.collection,
        id: 'druid:bb222ff5555',
        version: 1,
        label: 'factory collection label',
        title: 'factory collection title',
        admin_policy_id: 'druid:hv992ry2431',
        source_id: 'sulcollection:1234'
      }.freeze

      REQUEST_COLLECTION_DEFAULTS = COLLECTION_DEFAULTS.except(:id)

      ADMIN_POLICY_DEFAULTS = {
        type: Cocina::Models::ObjectType.admin_policy,
        id: 'druid:cb432gf8765',
        version: 1,
        label: 'factory APO label',
        title: 'factory APO title',
        admin_policy_id: 'druid:hv992ry2431',
        agreement_id: 'druid:hp308wm0436'
      }.freeze

      REQUEST_ADMIN_POLICY_DEFAULTS = ADMIN_POLICY_DEFAULTS.except(:id)

      def self.build_dro_properties(id:, **kwargs)
        build_request_dro_properties(**kwargs)
          .merge(externalIdentifier: id)
          .tap do |props|
          props[:description][:purl] = "https://purl.stanford.edu/#{id.delete_prefix('druid:')}"
        end
      end

      def self.build_dro(attributes)
        Cocina::Models.build(build_dro_properties(**DRO_DEFAULTS.merge(attributes)))
      end

      def self.build_dro_lite(attributes)
        Cocina::Models.build_lite(build_dro_properties(**DRO_DEFAULTS.merge(attributes)))
      end

      # rubocop:disable Metrics/ParameterLists
      def self.build_request_dro_properties(type:, version:, label:, title:, source_id:, admin_policy_id:,
                                            barcode: nil, catkeys: [], folio_instance_hrids: [], collection_ids: [])
        {
          type: type,
          version: version,
          label: label,
          access: {},
          administrative: { hasAdminPolicy: admin_policy_id },
          description: {
            title: [{ value: title }]
          },
          identification: {
            sourceId: source_id
          },
          structural: {
            isMemberOf: collection_ids
          }
        }.tap do |props|
          if catkeys.present?
            props[:identification][:catalogLinks] = catkeys.map.with_index do |catkey, index|
              { catalog: 'symphony', catalogRecordId: catkey, refresh: index.zero? }
            end
          end
          if folio_instance_hrids.present?
            props[:identification][:catalogLinks] = folio_instance_hrids.map.with_index do |folio_id, index|
              { catalog: 'folio', catalogRecordId: folio_id, refresh: index.zero? }
            end
          end
          props[:identification][:barcode] = barcode if barcode
        end
      end
      # rubocop:enable Metrics/ParameterLists

      def self.build_request_dro(attributes)
        Cocina::Models.build_request(build_request_dro_properties(**REQUEST_DRO_DEFAULTS.merge(attributes)))
      end

      def self.build_collection_properties(id:, **kwargs)
        build_request_collection_properties(**kwargs)
          .merge(externalIdentifier: id)
          .tap do |props|
          props[:description][:purl] = "https://purl.stanford.edu/#{id.delete_prefix('druid:')}"
        end
      end

      # rubocop:disable Metrics/ParameterLists
      def self.build_request_collection_properties(type:, version:, label:, title:, admin_policy_id:, source_id: nil, catkeys: [], folio_instance_hrids: [])
        {
          type: type,
          version: version,
          label: label,
          access: {},
          administrative: { hasAdminPolicy: admin_policy_id },
          description: {
            title: [{ value: title }]
          },
          identification: {}
        }.tap do |props|
          if catkeys.present?
            props[:identification][:catalogLinks] = catkeys.map.with_index do |catkey, index|
              { catalog: 'symphony', catalogRecordId: catkey, refresh: index.zero? }
            end
          end
          if folio_instance_hrids.present?
            props[:identification][:catalogLinks] = folio_instance_hrids.map.with_index do |folio_id, index|
              { catalog: 'folio', catalogRecordId: folio_id, refresh: index.zero? }
            end
          end
          props[:identification][:sourceId] = source_id if source_id
        end
      end
      # rubocop:enable Metrics/ParameterLists

      def self.build_collection(attributes)
        Cocina::Models.build(build_collection_properties(**COLLECTION_DEFAULTS.merge(attributes)))
      end

      def self.build_collection_lite(attributes)
        Cocina::Models.build_lite(build_collection_properties(**COLLECTION_DEFAULTS.merge(attributes)))
      end

      def self.build_request_collection(attributes)
        Cocina::Models.build_request(build_request_collection_properties(**REQUEST_COLLECTION_DEFAULTS.merge(attributes)))
      end

      def self.build_admin_policy(attributes)
        Cocina::Models.build(build_admin_policy_properties(**ADMIN_POLICY_DEFAULTS.merge(attributes)))
      end

      def self.build_admin_policy_lite(attributes)
        Cocina::Models.build_lite(build_admin_policy_properties(**ADMIN_POLICY_DEFAULTS.merge(attributes)))
      end

      def self.build_request_admin_policy(attributes)
        Cocina::Models.build_request(build_request_admin_policy_properties(**REQUEST_ADMIN_POLICY_DEFAULTS.merge(attributes)))
      end

      def self.build_admin_policy_properties(id:, **kwargs)
        build_request_admin_policy_properties(**kwargs)
          .merge(externalIdentifier: id)
          .tap do |props|
          props[:description][:purl] = "https://purl.stanford.edu/#{id.delete_prefix('druid:')}"
        end
      end

      # rubocop:disable Metrics/ParameterLists
      def self.build_request_admin_policy_properties(type:, version:, label:, title:,
                                                     admin_policy_id:, agreement_id:,
                                                     use_statement: nil, copyright: nil, license: nil,
                                                     registration_workflow: nil, collections_for_registration: nil,
                                                     without_description: false)
        {
          type: type,
          version: version,
          label: label,
          administrative: {
            hasAdminPolicy: admin_policy_id,
            hasAgreement: agreement_id,
            accessTemplate: {
              view: 'world',
              download: 'world'
            }
          },
          description: {
            title: [{ value: title }]
          }
        }.tap do |props|
          props[:administrative][:accessTemplate][:useAndReproductionStatement] = use_statement if use_statement
          props[:administrative][:accessTemplate][:copyright] = copyright if copyright
          props[:administrative][:accessTemplate][:license] = license if license
          props[:administrative][:registrationWorkflow] = registration_workflow if registration_workflow
          props[:administrative][:collectionsForRegistration] = collections_for_registration if collections_for_registration
          props.delete(:description) if without_description
        end
      end
      # rubocop:enable Metrics/ParameterLists
    end
  end
end
