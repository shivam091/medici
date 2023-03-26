# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class TaxRates::CreateService < ApplicationService
  def initialize(tax_rate_attributes)
    @tax_rate_attributes = tax_rate_attributes.dup
  end

  def call
    create_tax_rate
  end

  private

  attr_reader :tax_rate_attributes

  def create_tax_rate
    tax_rate = ::TaxRate.new(tax_rate_attributes)
    if tax_rate.save
      ::ServiceResponse.success(
        message: t("tax_rates.create.success", country_name: tax_rate.country_name),
        payload: {tax_rate: tax_rate}
      )
    else
      ::ServiceResponse.error(
        message: t("tax_rates.create.error"),
        payload: {tax_rate: tax_rate}
      )
    end
  end
end
