# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Manufacturers::DeactivateService < ApplicationService
  def initialize(manufacturer)
    @manufacturer = manufacturer
  end

  def call
    deactivate_manufacturer
  end

  private

  attr_reader :manufacturer

  def deactivate_manufacturer
    if manufacturer.deactivate!
      ::ServiceResponse.success(
        message: t("manufacturers.deactivate.success", manufacturer_name: manufacturer.name),
        payload: {manufacturer: manufacturer}
      )
    else
      ::ServiceResponse.error(
        message: t("manufacturers.deactivate.error", manufacturer_name: manufacturer.name),
        payload: {manufacturer: manufacturer}
      )
    end
  end
end
