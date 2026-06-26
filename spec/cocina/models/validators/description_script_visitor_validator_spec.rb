# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::DescriptionScriptVisitorValidator do
  let(:clazz) { Cocina::Models::Description }
  let(:validate) { Cocina::Models::Validators::CompositeDescriptionValidator.new(clazz, props, validators: [described_class]).validate }

  let(:base_props) do
    {
      title: [{ value: 'Test Title' }],
      purl: 'https://purl.stanford.edu/bc123df4567'
    }.with_indifferent_access
  end

  describe 'language script code validation' do
    context 'when language script has valid source and a valid code (Latn)' do
      let(:props) { base_props.merge(language: [{ code: 'eng', script: { code: 'Latn', source: { code: 'iso15924' } } }]) }

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    context 'when language script has valid source and a valid code with different case (latn)' do
      let(:props) { base_props.merge(language: [{ code: 'eng', script: { code: 'latn', source: { code: 'iso15924' } } }]) }

      it 'is case-insensitive and does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    context 'when language script has valid source and a valid private-use code (Qaaf)' do
      let(:props) { base_props.merge(language: [{ code: 'eng', script: { code: 'Qaaf', source: { code: 'iso15924' } } }]) }

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    context 'when language script has valid source and an invalid code (Aaaa)' do
      let(:props) { base_props.merge(language: [{ code: 'eng', script: { code: 'Aaaa', source: { code: 'iso15924' } } }]) }

      it 'raises ValidationError with path and code' do
        expect { validate }.to raise_error(
          Cocina::Models::ValidationError,
          'Unrecognized script codes in description: language1.script.code (Aaaa)'
        )
      end
    end

    context 'when language script has no source but has a code' do
      let(:props) { base_props.merge(language: [{ code: 'eng', script: { code: 'Aaaa' } }]) }

      it 'does not raise (code only validated when source is iso15924)' do
        expect { validate }.not_to raise_error
      end
    end
  end

  describe 'valueLanguage valueScript source.code validation' do
    context 'when title has valueLanguage without valueScript' do
      let(:props) { base_props.merge(title: [{ value: 'Test Title', valueLanguage: { code: 'eng' } }]) }

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    context 'when title valueLanguage valueScript has no source' do
      let(:props) { base_props.merge(title: [{ value: 'Test Title', valueLanguage: { code: 'eng', valueScript: { code: 'Latn' } } }]) }

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    context 'when title valueLanguage valueScript source has no code' do
      let(:props) { base_props.merge(title: [{ value: 'Test Title', valueLanguage: { code: 'eng', valueScript: { code: 'Latn', source: { uri: 'https://example.com' } } } }]) }

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    context 'when title valueLanguage valueScript has a valid source code (iso15924)' do
      let(:props) { base_props.merge(title: [{ value: 'Test Title', valueLanguage: { code: 'eng', valueScript: { code: 'Latn', source: { code: 'iso15924' } } } }]) }

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    context 'when title valueLanguage valueScript has a valid source code with different case (ISO15924)' do
      let(:props) { base_props.merge(title: [{ value: 'Test Title', valueLanguage: { code: 'eng', valueScript: { code: 'Latn', source: { code: 'ISO15924' } } } }]) }

      it 'is case-insensitive and does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    context 'when title valueLanguage valueScript has a non-iso15924 source code' do
      let(:props) { base_props.merge(title: [{ value: 'Test Title', valueLanguage: { code: 'Aaaa', valueScript: { code: 'Latn', source: { code: 'iso' } } } }]) }

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end
  end

  describe 'valueLanguage valueScript code validation' do
    context 'when title valueLanguage valueScript has valid source and a valid code (Cyrl)' do
      let(:props) { base_props.merge(title: [{ value: 'Test Title', valueLanguage: { code: 'rus', valueScript: { code: 'Cyrl', source: { code: 'iso15924' } } } }]) }

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    context 'when title valueLanguage valueScript has valid source and an invalid code (Aaaa)' do
      let(:props) { base_props.merge(title: [{ value: 'Test Title', valueLanguage: { code: 'rus', valueScript: { code: 'Aaaa', source: { code: 'iso15924' } } } }]) }

      it 'raises ValidationError with path and code' do
        expect { validate }.to raise_error(
          Cocina::Models::ValidationError,
          'Unrecognized script codes in description: title1.valueLanguage.valueScript.code (Aaaa)'
        )
      end
    end

    context 'when title valueLanguage valueScript has no source but has an invalid code' do
      let(:props) { base_props.merge(title: [{ value: 'Test Title', valueLanguage: { code: 'rus', valueScript: { code: 'Aaaa' } } }]) }

      it 'does not raise (code only validated when source is iso15924)' do
        expect { validate }.not_to raise_error
      end
    end
  end

  describe 'when using RequestDescription class' do
    let(:clazz) { Cocina::Models::RequestDescription }
    let(:props) { base_props.merge(language: [{ code: 'eng', script: { code: 'Aaaa', source: { code: 'iso15924' } } }]) }

    it 'raises ValidationError' do
      expect { validate }.to raise_error(
        Cocina::Models::ValidationError,
        'Unrecognized script codes in description: language1.script.code (Aaaa)'
      )
    end
  end
end
