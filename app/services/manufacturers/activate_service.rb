# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Manufacturers::ActivateService < ApplicationService
  def initialize(manufacturer)
    @manufacturer = manufacturer
  end

  def call
    activate_manufacturer
  end

  private

  attr_reader :manufacturer

  def activate_manufacturer
    if manufacturer.activate!
      ::ServiceResponse.success(
        message: t("manufacturers.activate.success", manufacturer_name: manufacturer.name),
        payload: {manufacturer: manufacturer}
      )
    else
      ::ServiceResponse.error(
        message: t("manufacturers.activate.error", manufacturer_name: manufacturer.name),
        payload: {manufacturer: manufacturer}
      )
    end
  end
end
