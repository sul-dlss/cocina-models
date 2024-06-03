# frozen_string_literal: true

module Cocina
  module Models
    class Administrative < Struct
      # example: druid:bc123df4567
      attribute :hasAdminPolicy, Druid
    end
  end
end
