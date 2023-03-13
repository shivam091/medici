# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class PackingTypes::DestroyService < ApplicationService
  def initialize(packing_type)
    @packing_type = packing_type
  end

  def call
    destroy_packing_type
  end

  private

  attr_reader :packing_type

  def destroy_packing_type
    if packing_type.destroy
      ::ServiceResponse.success(
        message: t("packing_types.destroy.success", packing_type_name: packing_type.name),
        payload: {packing_type: packing_type}
      )
    else
      ::ServiceResponse.error(
        message: t("packing_types.destroy.error", packing_type_name: packing_type.name),
        payload: {packing_type: packing_type}
      )
    end
  end
end
