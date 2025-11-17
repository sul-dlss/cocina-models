# frozen_string_literal: true

module Cocina
  module Models
    class RequestAdministrative < BaseModel
      attr_accessor :hasAdminPolicy, :partOfProject
    end
  end
end
