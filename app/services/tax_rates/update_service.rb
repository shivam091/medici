# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class TaxRates::UpdateService < ApplicationService
  def initialize(tax_rate, tax_rate_attributes)
    @tax_rate = tax_rate
    @tax_rate_attributes = tax_rate_attributes.dup
  end

  def call
    update_tax_rate
  end

  private

  attr_reader :tax_rate, :tax_rate_attributes

  def update_tax_rate
    if tax_rate.update(tax_rate_attributes)
      ::ServiceResponse.success(
        message: t("tax_rates.update.success", country_name: tax_rate.country_name),
        payload: {tax_rate: tax_rate}
      )
    else
      ::ServiceResponse.error(
        message: t("tax_rates.update.error"),
        payload: {tax_rate: tax_rate}
      )
    end
  end
end
