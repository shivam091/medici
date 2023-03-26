# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Discounts::UpdateService < ApplicationService
  def initialize(discount, discount_attributes)
    @discount = discount
    @discount_attributes = discount_attributes.dup
  end

  def call
    update_discount
  end

  private

  attr_reader :discount, :discount_attributes

  def update_discount
    if discount.update(discount_attributes)
      ::ServiceResponse.success(
        message: t("discounts.update.success", country_name: discount.country_name),
        payload: {discount: discount}
      )
    else
      ::ServiceResponse.error(
        message: t("discounts.update.error"),
        payload: {discount: discount}
      )
    end
  end
end
