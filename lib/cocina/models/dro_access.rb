# frozen_string_literal: true

module Cocina
  module Models
    class DROAccess < Struct
      # Access level.
      # Validation of this property is relaxed. See the openapi for full validation.
      attribute :access, Types::Strict::String.optional.default('dark').meta(omittable: true)
      # Download access level.
      # Validation of this property is relaxed. See the openapi for full validation.
      attribute :download, Types::Strict::String.optional.default('none').meta(omittable: true)
      # If access is "location-based", which location should have access.
      # Validation of this property is relaxed. See the openapi for full validation.
      attribute :readLocation, Types::Strict::String.optional.meta(omittable: true)
      # Validation of this property is relaxed. See the openapi for full validation.
      attribute :controlledDigitalLending, Types::Strict::Bool.optional.meta(omittable: true)
      # The human readable copyright statement that applies
      # example: Copyright World Trade Organization
      attribute :copyright, Types::Strict::String.optional.meta(omittable: true)
      attribute :embargo, Embargo.optional.meta(omittable: true)
      # The human readable use and reproduction statement that applies
      # example: Property rights reside with the repository. Literary rights reside with the creators of the documents or their heirs. To obtain permission to publish or reproduce, please contact the Public Services Librarian of the Dept. of Special Collections (http://library.stanford.edu/spc).
      attribute :useAndReproductionStatement, Types::Strict::String.meta(omittable: true)
      # The license governing reuse of the DRO. Should be an IRI for known licenses (i.e. CC, RightsStatement.org URI, etc.).
      attribute :license, Types::Strict::String.enum('https://www.gnu.org/licenses/agpl.txt', 'https://www.apache.org/licenses/LICENSE-2.0', 'https://opensource.org/licenses/BSD-2-Clause', 'https://opensource.org/licenses/BSD-3-Clause', 'https://creativecommons.org/licenses/by/4.0/legalcode', 'https://creativecommons.org/licenses/by-nc/4.0/legalcode', 'https://creativecommons.org/licenses/by-nc-nd/4.0/legalcode', 'https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode', 'https://creativecommons.org/licenses/by-nd/4.0/legalcode', 'https://creativecommons.org/licenses/by-sa/4.0/legalcode', 'https://creativecommons.org/publicdomain/zero/1.0/legalcode', 'https://opensource.org/licenses/cddl1', 'https://www.eclipse.org/legal/epl-2.0', 'https://www.gnu.org/licenses/gpl-3.0-standalone.html', 'https://www.isc.org/downloads/software-support-policy/isc-license/', 'https://www.gnu.org/licenses/lgpl-3.0-standalone.html', 'https://opensource.org/licenses/MIT', 'https://www.mozilla.org/MPL/2.0/', 'https://opendatacommons.org/licenses/by/1-0/', 'http://opendatacommons.org/licenses/odbl/1.0/', 'https://opendatacommons.org/licenses/odbl/1-0/', 'https://creativecommons.org/publicdomain/mark/1.0/', 'https://opendatacommons.org/licenses/pddl/1-0/', 'https://creativecommons.org/licenses/by/3.0/legalcode', 'https://creativecommons.org/licenses/by-sa/3.0/legalcode', 'https://creativecommons.org/licenses/by-nd/3.0/legalcode', 'https://creativecommons.org/licenses/by-nc/3.0/legalcode', 'https://creativecommons.org/licenses/by-nc-sa/3.0/legalcode', 'https://creativecommons.org/licenses/by-nc-nd/3.0/legalcode', 'http://cocina.sul.stanford.edu/licenses/none').meta(omittable: true)
    end
  end
end
