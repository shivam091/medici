# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class PackingTypes::DeactivateService < ApplicationService
  def initialize(packing_type)
    @packing_type = packing_type
  end

  def call
    deactivate_packing_type
  end

  private

  attr_reader :packing_type

  def deactivate_packing_type
    if packing_type.deactivate!
      ::ServiceResponse.success(
        message: t("packing_types.deactivate.success", packing_type_name: packing_type.name),
        payload: {packing_type: packing_type}
      )
    else
      ::ServiceResponse.error(
        message: t("packing_types.deactivate.error", packing_type_name: packing_type.name),
        payload: {packing_type: packing_type}
      )
    end
  end
end
