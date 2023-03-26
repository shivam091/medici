# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class TaxRates::DestroyService < ApplicationService
  def initialize(tax_rate)
    @tax_rate = tax_rate
  end

  def call
    destroy_tax_rate
  end

  private

  attr_reader :tax_rate

  def destroy_tax_rate
    if tax_rate.destroy
      ::ServiceResponse.success(
        message: t("tax_rates.destroy.success", country_name: tax_rate.country_name),
        payload: {tax_rate: tax_rate}
      )
    else
      ::ServiceResponse.error(
        message: t("tax_rates.destroy.error", country_name: tax_rate.country_name),
        payload: {tax_rate: tax_rate}
      )
    end
  end
end
