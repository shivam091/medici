# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class PackingTypes::UpdateService < ApplicationService
  def initialize(packing_type, packing_type_attributes)
    @packing_type = packing_type
    @packing_type_attributes = packing_type_attributes.dup
  end

  def call
    update_packing_type
  end

  private

  attr_reader :packing_type, :packing_type_attributes

  def update_packing_type
    if packing_type.update(packing_type_attributes)
      ::ServiceResponse.success(
        message: t("packing_types.update.success", packing_type_name: packing_type.name),
        payload: {packing_type: packing_type}
      )
    else
      ::ServiceResponse.error(
        message: t("packing_types.update.error"),
        payload: {packing_type: packing_type}
      )
    end
  end
end
