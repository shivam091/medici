# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Manufacturers::UpdateService < ApplicationService
  def initialize(manufacturer, manufacturer_attributes)
    @manufacturer = manufacturer
    @manufacturer_attributes = manufacturer_attributes.dup
  end

  def call
    update_manufacturer
  end

  private

  attr_reader :manufacturer, :manufacturer_attributes

  def update_manufacturer
    if manufacturer.update(manufacturer_attributes)
      ::ServiceResponse.success(
        message: t("manufacturers.update.success", manufacturer_name: manufacturer.name),
        payload: {manufacturer: manufacturer}
      )
    else
      ::ServiceResponse.error(
        message: t("manufacturers.update.error"),
        payload: {manufacturer: manufacturer}
      )
    end
  end
end
