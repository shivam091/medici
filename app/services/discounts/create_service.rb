# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Discounts::CreateService < ApplicationService
  def initialize(discount_attributes)
    @discount_attributes = discount_attributes.dup
  end

  def call
    create_discount
  end

  private

  attr_reader :discount_attributes

  def create_discount
    discount = ::Discount.new(discount_attributes)
    if discount.save
      ::ServiceResponse.success(
        message: t("discounts.create.success", country_name: discount.country_name),
        payload: {discount: discount}
      )
    else
      ::ServiceResponse.error(
        message: t("discounts.create.error"),
        payload: {discount: discount}
      )
    end
  end
end
