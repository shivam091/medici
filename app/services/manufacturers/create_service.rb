# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Manufacturers::CreateService < ApplicationService
  def initialize(manufacturer_attributes)
    @manufacturer_attributes = manufacturer_attributes.dup
  end

  def call
    create_manufacturer
  end

  private

  attr_reader :manufacturer_attributes

  def create_manufacturer
    manufacturer = ::Manufacturer.new(manufacturer_attributes)
    if manufacturer.save
      ::ServiceResponse.success(
        message: t("manufacturers.create.success", manufacturer_name: manufacturer.name),
        payload: {manufacturer: manufacturer}
      )
    else
      ::ServiceResponse.error(
        message: t("manufacturers.create.error"),
        payload: {manufacturer: manufacturer}
      )
    end
  end
end
