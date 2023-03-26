# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Discounts::DestroyService < ApplicationService
  def initialize(discount)
    @discount = discount
  end

  def call
    destroy_discount
  end

  private

  attr_reader :discount

  def destroy_discount
    if discount.destroy
      ::ServiceResponse.success(
        message: t("discounts.destroy.success", country_name: discount.country_name),
        payload: {discount: discount}
      )
    else
      ::ServiceResponse.error(
        message: t("discounts.destroy.error", country_name: discount.country_name),
        payload: {discount: discount}
      )
    end
  end
end
