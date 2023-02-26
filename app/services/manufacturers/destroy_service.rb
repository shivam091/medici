# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Manufacturers::DestroyService < ApplicationService
  def initialize(manufacturer)
    @manufacturer = manufacturer
  end

  def call
    destroy_manufacturer
  end

  private

  attr_reader :manufacturer

  def destroy_manufacturer
    if manufacturer.destroy
      ::ServiceResponse.success(
        message: t("manufacturers.destroy.success", manufacturer_name: manufacturer.name),
        payload: {manufacturer: manufacturer}
      )
    else
      ::ServiceResponse.error(
        message: t("manufacturers.destroy.success", manufacturer_name: manufacturer.name),
        payload: {manufacturer: manufacturer}
      )
    end
  end
end
