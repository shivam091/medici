# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class PackingTypes::CreateService < ApplicationService
  def initialize(packing_type_attributes)
    @packing_type_attributes = packing_type_attributes.dup
  end

  def call
    create_packing_type
  end

  private

  attr_reader :packing_type_attributes

  def create_packing_type
    packing_type = ::PackingType.new(packing_type_attributes)
    if packing_type.save
      ::ServiceResponse.success(
        message: t("packing_types.create.success", packing_type_name: packing_type.name),
        payload: {packing_type: packing_type}
      )
    else
      ::ServiceResponse.error(
        message: t("packing_types.create.error"),
        payload: {packing_type: packing_type}
      )
    end
  end
end
